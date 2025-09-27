//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics
import Metal
internal import PNDependencyGraph
import PNShared

struct PNPipeline: PNStage {
    var io: PNGPUIO
    private var combineStage: PNCombineStage
    private var ssaoStage: PNSSAOStage
    private var postprocessStage: PNPostprocessStage
    private var gBufferStage: PNGBufferStage
    private var spotShadowStage: PNSpotShadowStage
    private var omniShadowStage: PNOmniShadowStage
    private var directionalShadowStage: PNDirectionalShadowStage
    private let graph = PNGraph()
    private let singlethreadVisitor: PNSingleThreadVisitor
    private let multithreadVisitor: PNMultithreadVisitor
    private let render: [String: ((MTLCommandBuffer, PNFrameSupply) -> Void)]
    init?(device: MTLDevice,
          renderingSize: CGSize) {
        guard let gBufferStage = PNGBufferStage(device: device,
                                                renderingSize: renderingSize),
              let spotShadowStage = PNSpotShadowStage(device: device,
                                                      shadowTextureSize: PNDefaults.shared.rendering.shadowSize),
              let directionalShadowStage = PNDirectionalShadowStage(device: device,
                                                                    shadowTextureSize: PNDefaults.shared.rendering.shadowSize),
              let omniShadowStage = PNOmniShadowStage(device: device,
                                                      shadowTextureSize: PNDefaults.shared.rendering.shadowSize),
              let ssaoStage = PNSSAOStage(device: device,
                                          renderingSize: renderingSize,
                                          prTexture: gBufferStage.io.output.color[2],
                                          nmTexture: gBufferStage.io.output.color[1],
                                          blurSigma: PNDefaults.shared.shaders.ssao.blurSigma),
              let combineStage = PNCombineStage(device: device,
                                                renderingSize: renderingSize,
                                                gBufferOutput: gBufferStage.io.output,
                                                ssaoTexture: ssaoStage.io.output.color[0],
                                                spotLightShadows: spotShadowStage.io.output.depth[0],
                                                pointLightsShadows: omniShadowStage.io.output.depth[0],
                                                directionalLightsShadows: directionalShadowStage.io.output.depth[0]),
              let postprocessStage = PNPostprocessStage(input: combineStage.io.output.color[0],
                                                        velocities: gBufferStage.io.output.color[3],
                                                        bloomBlurSigma: PNDefaults.shared.shaders.postprocess.bloom.blurSigma,
                                                        device: device,
                                                        renderingSize: renderingSize) else {
            return nil
        }
        self.gBufferStage = gBufferStage
        self.combineStage = combineStage
        self.postprocessStage = postprocessStage
        self.ssaoStage = ssaoStage
        self.omniShadowStage = omniShadowStage
        self.directionalShadowStage = directionalShadowStage
        self.spotShadowStage = spotShadowStage
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(color: postprocessStage.io.output.color))

        let directionalShadows = graph.add(identifier: "DirectionalShadows")
        let omniShadows = graph.add(identifier: "OmniShadows")
        let spotShadow = graph.add(identifier: "SpotShadow")
        let gBuffer = graph.add(identifier: "GBuffer")
        let ssao = graph.add(identifier: "SSAO")
        let combine = graph.add(identifier: "Combine")
        let postprocess = graph.add(identifier: "Postprocess")

        ssao.addDependency(node: gBuffer)
        combine.addDependency(node: ssao)
        combine.addDependency(node: spotShadow)
        combine.addDependency(node: omniShadows)
        combine.addDependency(node: directionalShadows)
        postprocess.addDependency(node: combine)

        guard let compiled = try? graph.compile() else {
            fatalError("Could not compile the graph")
        }

        singlethreadVisitor = PNSingleThreadVisitor(graph: compiled)
        multithreadVisitor = PNMultithreadVisitor(graph: compiled)

        var renderTasks = [String: ((MTLCommandBuffer, PNFrameSupply) -> Void)]()
        renderTasks["GBuffer"] = { commandBuffer, supply in
            gBufferStage.draw(commandBuffer: commandBuffer,
                              supply: supply)
        }
        renderTasks["SpotShadow"] = { commandBuffer, supply in
            spotShadowStage.draw(commandBuffer: commandBuffer, supply: supply)
        }
        renderTasks["DirectionalShadows"] = { commandBuffer, supply in
            directionalShadowStage.draw(commandBuffer: commandBuffer,
                                        supply: supply)
        }
        renderTasks["OmniShadows"] = { commandBuffer, supply in
            omniShadowStage.draw(commandBuffer: commandBuffer,
                                 supply: supply)
        }
        renderTasks["Combine"] = { commandBuffer, supply in
            combineStage.draw(commandBuffer: commandBuffer,
                              supply: supply)
        }
        renderTasks["SSAO"] = { commandBuffer, supply in
            if !supply.scene.ambientLights.isEmpty {
                ssaoStage.draw(commandBuffer: commandBuffer,
                               supply: supply)
            }
        }
        renderTasks["Postprocess"] = { commandBuffer, supply in
            postprocessStage.draw(commandBuffer: commandBuffer,
                                  supply: supply)
        }
        render = renderTasks
    }
    func draw(commandQueue: MTLCommandQueue, supply: PNFrameSupply) {
        let wholeEncoding = psignposter.beginInterval("Whole encoding")
        var commandBuffers = [String: MTLCommandBuffer]()
        singlethreadVisitor.visit { node in
            guard let commandBuffer = commandQueue.makeCommandBuffer(descriptor: .noLogButRetain) else {
                fatalError("Could not create command buffer")
            }
            commandBuffers[node.identifier] = commandBuffer
            commandBuffer.enqueue()
        }
        let immuteBuffers = commandBuffers
        multithreadVisitor.visit { node in
            let encodingInterval = psignposter.beginInterval("Encoding", "\(node.identifier)")
            guard let commandBuffer = immuteBuffers[node.identifier] else {
                fatalError("Cannot create command buffer")
            }
            render[node.identifier]?(commandBuffer, supply)
            psignposter.endInterval("Encoding", encodingInterval)
            commandBuffer.commit()
        }
        psignposter.endInterval("Whole encoding", wholeEncoding)
    }
}

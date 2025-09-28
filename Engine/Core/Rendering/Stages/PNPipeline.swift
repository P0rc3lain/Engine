//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics
import Metal
import MetalKit
import MetalPerformanceShaders
internal import PNDependencyGraph
import PNShared

class PNPipeline: PNStage {
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
    private var render = [String: ((MTLCommandBuffer, PNFrameSupply) -> Void)]()
    private let imageConverter: MPSImageConversion
    init?(device: MTLDevice,
          renderingSize: CGSize,
          view: MTKView) {
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
                                          scaleSize: PNDefaults.shared.shaders.ssao.renderingScale,
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
                                                        bloomRenderingScale: PNDefaults.shared.shaders.postprocess.bloom.renderingScale,
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
        self.imageConverter = MPSImageConversion(device: device)
        let directionalShadows = graph.add(identifier: "DirectionalShadows")
        let omniShadows = graph.add(identifier: "OmniShadows")
        let spotShadow = graph.add(identifier: "SpotShadow")
        let gBuffer = graph.add(identifier: "GBuffer")
        let ssao = graph.add(identifier: "SSAO")
        let combine = graph.add(identifier: "Combine")
        let postprocess = graph.add(identifier: "Postprocess")
        let finalConversion = graph.add(identifier: "FinalConversion")

        ssao.addDependency(node: gBuffer)
        combine.addDependency(node: ssao)
        combine.addDependency(node: spotShadow)
        combine.addDependency(node: omniShadows)
        combine.addDependency(node: directionalShadows)
        postprocess.addDependency(node: combine)
        finalConversion.addDependency(node: postprocess)

        guard let compiled = try? graph.compile() else {
            fatalError("Could not compile the graph")
        }

        singlethreadVisitor = PNSingleThreadVisitor(graph: compiled)
        multithreadVisitor = PNMultithreadVisitor(graph: compiled)

        render["GBuffer"] = { commandBuffer, supply in
            gBufferStage.draw(commandBuffer: commandBuffer,
                              supply: supply)
        }
        render["SpotShadow"] = { commandBuffer, supply in
            spotShadowStage.draw(commandBuffer: commandBuffer,
                                 supply: supply)
        }
        render["DirectionalShadows"] = { commandBuffer, supply in
            directionalShadowStage.draw(commandBuffer: commandBuffer,
                                        supply: supply)
        }
        render["OmniShadows"] = { commandBuffer, supply in
            omniShadowStage.draw(commandBuffer: commandBuffer,
                                 supply: supply)
        }
        render["Combine"] = { commandBuffer, supply in
            combineStage.draw(commandBuffer: commandBuffer,
                              supply: supply)
        }
        render["SSAO"] = { commandBuffer, supply in
            guard !supply.scene.ambientLights.isEmpty else {
                return
            }
            ssaoStage.draw(commandBuffer: commandBuffer,
                           supply: supply)
        }
        render["Postprocess"] = { commandBuffer, supply in
            postprocessStage.draw(commandBuffer: commandBuffer,
                                  supply: supply)
        }
        render["FinalConversion"] = { [weak self] commandBuffer, _ in
            guard let self,
                  let drawable = view.currentDrawable,
                  let sourceTexture = postprocessStage.io.output.color.first?.texture else {
                fatalError("Cannot retrieve required input data")
            }
            imageConverter.encode(commandBuffer: commandBuffer,
                                  sourceTexture: sourceTexture,
                                  destinationTexture: drawable.texture)
            commandBuffer.present(drawable)
        }
    }
    func draw(commandQueue: MTLCommandQueue, supply: PNFrameSupply) {
        let wholeEncoding = psignposter.beginInterval("Whole encoding")
        var commandBuffers = [String: MTLCommandBuffer]()
        singlethreadVisitor.visit { node in
            guard let commandBuffer = commandQueue.makeCommandBuffer(descriptor: .noLogButRetain) else {
                fatalError("Could not create command buffer")
            }
            commandBuffers[node.identifier] = commandBuffer
            commandBuffer.label = "Stage \(node.identifier)"
            commandBuffer.enqueue()
        }
        let immuteBuffers = commandBuffers
        multithreadVisitor.visit { [weak self] node in
            guard let self else { return }
            let encodingInterval = psignposter.beginInterval("Encoding", "\(node.identifier)")
            guard let commandBuffer = immuteBuffers[node.identifier] else {
                fatalError("Cannot create command buffer")
            }
            render[node.identifier]?(commandBuffer, supply)
            psignposter.endInterval("Encoding", encodingInterval)
            commandBuffer.commit()
        }
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            fatalError("Could not prepare command buffer for synchronization")
        }
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        psignposter.endInterval("Whole encoding", wholeEncoding)
    }
}

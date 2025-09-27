//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics
import Metal
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
    }
    func draw(commandQueue: MTLCommandQueue, supply: PNFrameSupply) {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            fatalError("Could not create command buffer for spot shadow stage")
        }
        spotShadowStage.draw(commandBuffer: commandBuffer,
                             supply: supply)
        commandBuffer.commit()
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            fatalError("Could not create command buffer for omni shadow stage")
        }
        omniShadowStage.draw(commandBuffer: commandBuffer,
                             supply: supply)
        commandBuffer.commit()
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            fatalError("Could not create command buffer for directional shadow stage")
        }
        directionalShadowStage.draw(commandBuffer: commandBuffer,
                                    supply: supply)
        commandBuffer.commit()
        gBufferStage.draw(commandQueue: commandQueue,
                          supply: supply)
        if !supply.scene.ambientLights.isEmpty {
            ssaoStage.draw(commandQueue: commandQueue,
                           supply: supply)
        }
        combineStage.draw(commandQueue: commandQueue,
                          supply: supply)
        postprocessStage.draw(commandQueue: commandQueue,
                              supply: supply)
    }
}

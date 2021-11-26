//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

struct PNPipeline: PNStage {
    var io: PNGPUIO
    private var combineStage: PNCombineStage
    private var ssaoStage: PNSSAOStage
    private var bloomStage: PNBloomStage
    private var gBufferStage: PNGBufferStage
    private var shadowStage: PNShadowStage
    private var postprocessStage: PNPostprocessStage
    init?(device: MTLDevice, renderingSize: CGSize) {
        guard let gBufferStage = PNGBufferStage(device: device,
                                                renderingSize: renderingSize),
              let shadowStage = PNShadowStage(device: device,
                                              spotShadowTextureSideSize: 1_024,
                                              spotLightsNumber: 1,
                                              omniLightsNumber: 1),
              let ssaoStage = PNSSAOStage(device: device,
                                          renderingSize: renderingSize,
                                          prTexture: gBufferStage.io.output.color[2],
                                          nmTexture: gBufferStage.io.output.color[1],
                                          blurSigma: 5),
              let combineStage = PNCombineStage(device: device,
                                                renderingSize: renderingSize,
                                                gBufferOutput: gBufferStage.io.output,
                                                ssaoTexture: ssaoStage.io.output.color[0],
                                                spotLightShadows: shadowStage.io.output.depth[0],
                                                pointLightsShadows: shadowStage.io.output.depth[1]),
              let bloomStage = PNBloomStage(input: combineStage.io.output.color[0],
                                            device: device,
                                            renderingSize: renderingSize),
              let postprocessStage = PNPostprocessStage(device: device,
                                                        inputTexture: bloomStage.io.output.color[0],
                                                        renderingSize: renderingSize) else {
            return nil
        }
        self.gBufferStage = gBufferStage
        self.combineStage = combineStage
        self.bloomStage = bloomStage
        self.ssaoStage = ssaoStage
        self.postprocessStage = postprocessStage
        self.shadowStage = shadowStage
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(color: postprocessStage.io.output.color))
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        shadowStage.draw(commandBuffer: commandBuffer,
                         supply: supply)
        gBufferStage.draw(commandBuffer: commandBuffer,
                          supply: supply)
        if !supply.scene.ambientLights.isEmpty {
            ssaoStage.draw(commandBuffer: commandBuffer,
                           supply: supply)
        }
        combineStage.draw(commandBuffer: commandBuffer,
                          supply: supply)
        bloomStage.draw(commandBuffer: commandBuffer,
                        supply: supply)
        postprocessStage.draw(commandBuffer: commandBuffer,
                              supply: supply)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

struct Pipeline: Stage {
    var io: GPUIO
    private var combineStage: CombineStage
    private var ssaoStage: SSAOStage
    private var bloomStage: BloomStage
    private var gBufferStage: GBufferStage
    private var shadowStage: ShadowStage
    private var postprocessStage: PostprocessStage
    init?(device: MTLDevice, renderingSize: CGSize) {
        guard let gBufferStage = GBufferStage(device: device,
                                              renderingSize: renderingSize),
              let shadowStage = ShadowStage(device: device,
                                            spotShadowTextureSideSize: 1_024,
                                            spotLightsNumber: 1,
                                            omniLightsNumber: 1),
              let ssaoStage = SSAOStage(device: device,
                                        renderingSize: renderingSize,
                                        prTexture: gBufferStage.io.output.color[2],
                                        nmTexture: gBufferStage.io.output.color[1],
                                        blurSigma: 5),
              let combineStage = CombineStage(device: device,
                                              renderingSize: renderingSize,
                                              gBufferOutput: gBufferStage.io.output,
                                              ssaoTexture: ssaoStage.io.output.color[0],
                                              spotLightShadows: shadowStage.io.output.depth[0],
                                              pointLightsShadows: shadowStage.io.output.depth[1]),
              let bloomStage = BloomStage(input: combineStage.io.output.color[0],
                                          device: device,
                                          renderingSize: renderingSize),
              let postprocessStage = PostprocessStage(device: device,
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
        self.io = GPUIO(input: .empty,
                        output: GPUSupply(color: postprocessStage.io.output.color))
    }
    mutating func draw(commandBuffer: inout MTLCommandBuffer,
                       scene: inout GPUSceneDescription,
                       bufferStore: inout BufferStore,
                       transformedEntities: inout [ModelUniforms]) {
        shadowStage.draw(commandBuffer: &commandBuffer,
                         scene: &scene,
                         bufferStore: &bufferStore)
        gBufferStage.draw(commandBuffer: &commandBuffer,
                          scene: &scene,
                          bufferStore: &bufferStore,
                          modelUniforms: &transformedEntities)
        if !scene.ambientLights.isEmpty {
            ssaoStage.draw(commandBuffer: &commandBuffer,
                           bufferStore: &bufferStore)
        }
        combineStage.draw(commandBuffer: &commandBuffer,
                          scene: &scene,
                          bufferStore: &bufferStore)
        bloomStage.draw(commandBuffer: &commandBuffer)
        postprocessStage.draw(commandBuffer: &commandBuffer)
    }
}

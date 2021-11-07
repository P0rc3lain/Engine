//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

struct Pipeline: Stage {
    var io: GPUIO
    private var combineStage: CombineStage
    private var ssaoStage: SSAOStage
    private var bloomStage: BloomStage
    private var gBufferStage: GBufferStage
    private var postprocessStage: PostprocessStage
    init?(device: MTLDevice, renderingSize: CGSize) {
        guard let gBufferStage = GBufferStage(device: device, renderingSize: renderingSize),
              let ssaoStage = SSAOStage(device: device,
                                        renderingSize: renderingSize,
                                        prTexture: gBufferStage.io.output.color[2],
                                        nmTexture: gBufferStage.io.output.color[1]),
              let combineStage = CombineStage(device: device,
                                              renderingSize: renderingSize,
                                              gBufferOutput: gBufferStage.io.output,
                                              ssaoTexture: ssaoStage.io.output.color[0]),
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
        self.io = GPUIO(input: GPUSupply(), output: GPUSupply(color: postprocessStage.io.output.color))
    }
    mutating func draw(commandBuffer: inout MTLCommandBuffer,
                       scene: inout GPUSceneDescription,
                       bufferStore: inout BufferStore) {
        gBufferStage.draw(commandBuffer: &commandBuffer, scene: &scene, bufferStore: &bufferStore)
        ssaoStage.draw(commandBuffer: &commandBuffer, bufferStore: &bufferStore)
        combineStage.draw(commandBuffer: &commandBuffer, scene: &scene, bufferStore: &bufferStore)
        bloomStage.draw(commandBuffer: &commandBuffer)
        postprocessStage.draw(commandBuffer: &commandBuffer)
    }
}

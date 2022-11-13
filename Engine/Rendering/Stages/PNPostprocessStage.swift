//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation
import Metal

struct PNPostprocessStage: PNStage {
    var io: PNGPUIO
    private var postprocessingJob: PNPostprocessingJob
    init?(device: MTLDevice, inputTexture: PNTextureProvider) {
        guard let postprocessingJob = PNPostprocessingJob.make(device: device,
                                                               inoutTexture: inputTexture) else {
            return nil
        }
        self.postprocessingJob = postprocessingJob
        self.io = PNGPUIO(input: PNGPUSupply(color: [inputTexture]),
                          output: PNGPUSupply(color: [inputTexture]))
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        commandBuffer.pushDebugGroup("Post Processing Pass")
        guard let encoder = commandBuffer.makeComputeCommandEncoder() else {
            return
        }
        postprocessingJob.compute(encoder: encoder, supply: supply)
        encoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}

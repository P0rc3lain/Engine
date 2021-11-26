//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation
import Metal

struct PNPostprocessStage: PNStage {
    var io: PNGPUIO
    private var vignetteJob: PNVignetteJob
    private var postprocessRenderPassDescriptor: MTLRenderPassDescriptor
    init?(device: MTLDevice, inputTexture: MTLTexture, renderingSize: CGSize) {
        self.postprocessRenderPassDescriptor = .postprocess(device: device, size: renderingSize)
        guard let vignetteJob = PNVignetteJob.make(device: device,
                                                   inputTexture: inputTexture,
                                                   canvasSize: renderingSize),
              let outputTexture = postprocessRenderPassDescriptor.colorAttachments[0].texture else {
            return nil
        }
        self.vignetteJob = vignetteJob
        self.io = PNGPUIO(input: PNGPUSupply(color: [inputTexture]),
                          output: PNGPUSupply(color: [outputTexture]))
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: postprocessRenderPassDescriptor) else {
            return
        }
        commandBuffer.pushDebugGroup("Post Processing Pass")
        vignetteJob.draw(encoder: encoder, supply: supply)
        encoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}

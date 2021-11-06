//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation
import Metal

struct PostprocessStage: Stage {
    var io: GPUIO
    private var postProcessor: Postprocessor
    private var postprocessRenderPassDescriptor: MTLRenderPassDescriptor
    init?(device: MTLDevice, inputTexture: MTLTexture, renderingSize: CGSize) {
        self.postprocessRenderPassDescriptor = .postprocess(device: device, size: renderingSize)
        guard let postProcessor = Postprocessor.make(device: device,
                                                     inputTexture: inputTexture,
                                                     canvasSize: renderingSize),
              let outputTexture = postprocessRenderPassDescriptor.colorAttachments[0].texture else {
            return nil
        }
        self.postProcessor = postProcessor
        self.io = GPUIO(input: GPUSupply(color: [inputTexture]),
                        output: GPUSupply(color: [outputTexture]))
    }
    func draw(commandBuffer: inout MTLCommandBuffer) {
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: postprocessRenderPassDescriptor) else {
            return
        }
        commandBuffer.pushDebugGroup("Post Processing Pass")
        postProcessor.draw(encoder: encoder)
        encoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}

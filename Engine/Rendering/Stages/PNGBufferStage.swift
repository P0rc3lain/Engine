//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

struct PNGBufferStage: PNStage {
    var io: PNGPUIO
    private var gBufferRenderPassDescriptor: MTLRenderPassDescriptor
    private let gBufferJob: PNRenderJob
    init?(device: MTLDevice, renderingSize: CGSize) {
        gBufferRenderPassDescriptor = .gBuffer(device: device, size: renderingSize)
        guard let gBufferJob = PNGBufferJob.make(device: device, drawableSize: renderingSize),
              let arTexture = gBufferRenderPassDescriptor.colorAttachments[0].texture,
              let nmTexture = gBufferRenderPassDescriptor.colorAttachments[1].texture,
              let prTexture = gBufferRenderPassDescriptor.colorAttachments[2].texture,
              let stencil = gBufferRenderPassDescriptor.stencilAttachment.texture else {
            return nil
        }
        self.gBufferJob = gBufferJob
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(color: [arTexture, nmTexture, prTexture],
                                              stencil: [stencil]))
    }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply) {
        commandBuffer.pushDebugGroup("G-Buffer Renderer Pass")
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: gBufferRenderPassDescriptor) else {
            return
        }
        gBufferJob.draw(encoder: encoder, supply: supply)
        encoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}

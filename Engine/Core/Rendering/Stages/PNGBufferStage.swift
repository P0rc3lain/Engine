//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics
import Metal
import PNShared

struct PNGBufferStage: PNStage {
    var io: PNGPUIO
    private var gBufferRenderPassDescriptor: MTLRenderPassDescriptor
    private let gBufferJob: PNRenderJob
    init?(device: MTLDevice, renderingSize: CGSize) {
        gBufferRenderPassDescriptor = .gBuffer(device: device, size: renderingSize)
        guard let gBufferJob = PNGBufferJob.make(device: device),
              let arTexture = gBufferRenderPassDescriptor.colorAttachments[0].texture,
              let nmTexture = gBufferRenderPassDescriptor.colorAttachments[1].texture,
              let prTexture = gBufferRenderPassDescriptor.colorAttachments[2].texture,
              let velocityTexture = gBufferRenderPassDescriptor.colorAttachments[3].texture,
              let stencil = gBufferRenderPassDescriptor.stencilAttachment.texture,
              let depth = gBufferRenderPassDescriptor.depthAttachment.texture else {
            return nil
        }
        self.gBufferJob = gBufferJob
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(color: [arTexture, nmTexture, prTexture, velocityTexture],
                                              stencil: [stencil],
                                              depth: [depth]))
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

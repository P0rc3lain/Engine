//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

struct GBufferStage: Stage {
    var io: PNGPUIO
    private var gBufferRenderPassDescriptor: MTLRenderPassDescriptor
    private let gBufferRenderer: GBufferRenderer
    init?(device: MTLDevice, renderingSize: CGSize) {
        gBufferRenderPassDescriptor = .gBuffer(device: device, size: renderingSize)
        guard let gBufferRenderer = GBufferRenderer.make(device: device, drawableSize: renderingSize),
              let arTexture = gBufferRenderPassDescriptor.colorAttachments[0].texture,
              let nmTexture = gBufferRenderPassDescriptor.colorAttachments[1].texture,
              let prTexture = gBufferRenderPassDescriptor.colorAttachments[2].texture,
              let stencil = gBufferRenderPassDescriptor.stencilAttachment.texture else {
            return nil
        }
        self.gBufferRenderer = gBufferRenderer
        self.io = PNGPUIO(input: .empty,
                          output: PNGPUSupply(color: [arTexture, nmTexture, prTexture],
                                              stencil: [stencil]))
    }
    mutating func draw(commandBuffer: inout MTLCommandBuffer,
                       scene: inout PNSceneDescription,
                       bufferStore: inout BufferStore,
                       arrangement: inout PNArrangement) {
        guard var gBufferEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: gBufferRenderPassDescriptor) else {
            return
        }
        commandBuffer.pushDebugGroup("G-Buffer Renderer Pass")
        gBufferRenderer.draw(encoder: &gBufferEncoder,
                             scene: &scene,
                             dataStore: &bufferStore,
                             arrangement: &arrangement)
        gBufferEncoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}

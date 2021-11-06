//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation
import Metal

struct GBufferStage: Stage {
    var io: GPUIO
    private var gBufferRenderPassDescriptor: MTLRenderPassDescriptor
    private let gBufferRenderer: GBufferRenderer
    init?(device: MTLDevice, renderingSize: CGSize) {
        gBufferRenderPassDescriptor = .gBuffer(device: device, size: renderingSize)
        guard let gBufferRenderer = GBufferRenderer.make(device: device, drawableSize: renderingSize) else {
            return nil
        }
        self.gBufferRenderer = gBufferRenderer
        self.io = GPUIO(input: GPUSupply(color: []), output: GPUSupply(color: [gBufferRenderPassDescriptor.colorAttachments[0].texture!,
                                                                               gBufferRenderPassDescriptor.colorAttachments[1].texture!,
                                                                               gBufferRenderPassDescriptor.colorAttachments[2].texture!],
                                                                      stencil: gBufferRenderPassDescriptor.stencilAttachment.texture))
    }
    mutating func draw(commandBuffer: inout MTLCommandBuffer, scene: inout GPUSceneDescription, bufferStore: inout BufferStore) {
        guard var gBufferEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: gBufferRenderPassDescriptor) else {
            return
        }
        commandBuffer.pushDebugGroup("G-Buffer Renderer Pass")
        gBufferRenderer.draw(encoder: &gBufferEncoder, scene: &scene, dataStore: &bufferStore)
        gBufferEncoder.endEncoding()
        commandBuffer.popDebugGroup()
    }
}

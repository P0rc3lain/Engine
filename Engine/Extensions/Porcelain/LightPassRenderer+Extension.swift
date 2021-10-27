//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension LightPassRenderer {
    static func make(device: MTLDevice, gBufferRenderPassDescriptor: MTLRenderPassDescriptor, drawableSize: CGSize) -> LightPassRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateLightRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateLightPass() else {
            return nil
        }
        return LightPassRenderer(pipelineState: pipelineState,
                                 gBufferRenderPass: gBufferRenderPassDescriptor,
                                 device: device,
                                 depthStencilState: depthStencilState,
                                 drawableSize: drawableSize)
    }
}

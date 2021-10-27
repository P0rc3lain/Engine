//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension GBufferRenderer {
    static func make(device: MTLDevice, drawableSize: CGSize) -> GBufferRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateGBufferRenderer(library: library),
              let animatedPipelineState = device.makeRenderPipelineStateGBufferAnimatedRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateGBufferRenderer() else {
            return nil
        }
        let renderPassDescriptor = MTLRenderPassDescriptor.gBuffer(device: device, size: drawableSize)
        return GBufferRenderer(pipelineState: pipelineState,
                               animatedPipelineState: animatedPipelineState,
                               depthStencilState: depthStencilState,
                               drawableSize: drawableSize,
                               renderPassRescriptor: renderPassDescriptor)
    }
}

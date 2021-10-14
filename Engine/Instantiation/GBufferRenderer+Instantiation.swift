//
//  GBufferRenderer+Instantiation.swift
//  Engine
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Metal

extension GBufferRenderer {
    static func make(device: MTLDevice, drawableSize: CGSize) -> GBufferRenderer {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRenderPipelineStateGBufferRenderer(library: library)
        let depthStencilState = device.makeDepthStencilStateGBufferRenderer()
        let renderPassDescriptor = MTLRenderPassDescriptor.gBuffer(device: device, size: drawableSize)
        return GBufferRenderer(pipelineState: pipelineState,
                               depthStencilState: depthStencilState,
                               drawableSize: drawableSize,
                               renderPassRescriptor: renderPassDescriptor)
    }
}

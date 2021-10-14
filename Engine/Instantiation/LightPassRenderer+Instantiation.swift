//
//  LightPassRenderer+Instantiation.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 15/11/2020.
//

import Metal

extension LightPassRenderer {
    static func make(device: MTLDevice, gBufferRenderPassDescriptor: MTLRenderPassDescriptor, drawableSize: CGSize) -> LightPassRenderer! {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRenderPipelineStateLightRenderer(library: library)
        let depthStencilState = device.makeDepthStencilStateLightPass()
        return LightPassRenderer(pipelineState: pipelineState,
                                 gBufferRenderPass: gBufferRenderPassDescriptor,
                                 device: device,
                                 depthStencilState: depthStencilState,
                                 drawableSize: drawableSize)
    }
}

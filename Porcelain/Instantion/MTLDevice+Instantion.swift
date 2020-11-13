//
//  MTLDevice.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 13/11/2020.
//

import Metal

extension MTLDevice {
    func makeDepthStencilStateForwardRenderer() -> MTLDepthStencilState {
        makeDepthStencilState(descriptor: MTLDepthStencilDescriptor.forwardRenderer)!
    }
    func makeRenderPipelineStateForwardRenderer(library: MTLLibrary) -> MTLRenderPipelineState {
        let description = MTLRenderPipelineDescriptor.forwardRenderer(library: library)
        return try! makeRenderPipelineState(descriptor: description)
    }
    func makeRenderPipelineStatePostprocessor(library: MTLLibrary,
                                              format: MTLPixelFormat) -> MTLRenderPipelineState {
        let descriptor = MTLRenderPipelineDescriptor.postProcessor(library: library, format: format)
        return try! makeRenderPipelineState(descriptor: descriptor)
    }
}

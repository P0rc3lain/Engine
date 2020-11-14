//
//  MTLDevice+Instantiation.swift
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
    func makeRenderPipelineStateEnvironmentRenderer(library: MTLLibrary) -> MTLRenderPipelineState {
        let descriptor = MTLRenderPipelineDescriptor.environmentRenderer(library: library)
        return try! makeRenderPipelineState(descriptor: descriptor)
    }
    func makeTextureLightenSceneDepth(size: CGSize) -> MTLTexture {
        makeTexture(descriptor: MTLTextureDescriptor.lightenSceneDepth(size: size))!
    }
    func makeTextureLightenSceneColor(size: CGSize) -> MTLTexture {
        makeTexture(descriptor: MTLTextureDescriptor.lightenSceneColor(size: size))!
    }
    func makePorcelainLibrary() -> MTLLibrary {
        try! makeDefaultLibrary(bundle: Bundle(for: Engine.self))
    }
}

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
    func makeDepthStencilStateGBufferRenderer() -> MTLDepthStencilState {
        makeDepthStencilState(descriptor: MTLDepthStencilDescriptor.forwardRenderer)!
    }
    func makeDepthStencilStateEnvironmentRenderer() -> MTLDepthStencilState {
        makeDepthStencilState(descriptor: MTLDepthStencilDescriptor.environmentRenderer)!
    }
    func makeDepthStencilStateLightPass() -> MTLDepthStencilState {
        makeDepthStencilState(descriptor: MTLDepthStencilDescriptor.lightPassRenderer)!
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
    func makeRenderPipelineStateGBufferRenderer(library: MTLLibrary) -> MTLRenderPipelineState {
        let descriptor = MTLRenderPipelineDescriptor.gBufferRenderer(library: library)
        return try! makeRenderPipelineState(descriptor: descriptor)
    }
    func makeRenderPipelineStateLightRenderer(library: MTLLibrary) -> MTLRenderPipelineState {
        let descriptor = MTLRenderPipelineDescriptor.lightRenderer(library: library)
        return try! makeRenderPipelineState(descriptor: descriptor)
    }
    func makeTextureLightenSceneDepthStencil(size: CGSize) -> MTLTexture {
        makeTexture(descriptor: MTLTextureDescriptor.lightenSceneDepthStencil(size: size))!
    }
    func makeTextureLightenSceneColor(size: CGSize) -> MTLTexture {
        makeTexture(descriptor: MTLTextureDescriptor.lightenSceneColor(size: size))!
    }
    func makeTextureGBufferAR(size: CGSize) -> MTLTexture {
        makeTexture(descriptor: MTLTextureDescriptor.gBufferAR(size: size))!
    }
    func makeTextureGBufferNM(size: CGSize) -> MTLTexture {
        makeTexture(descriptor: MTLTextureDescriptor.gBufferNM(size: size))!
    }
    func makeTextureGBufferPR(size: CGSize) -> MTLTexture {
        makeTexture(descriptor: MTLTextureDescriptor.gBufferPR(size: size))!
    }
    func makeTextureGBufferDepthStencil(size: CGSize) -> MTLTexture {
        makeTexture(descriptor: MTLTextureDescriptor.gBufferDepthStencil(size: size))!
    }
    func makePorcelainLibrary() -> MTLLibrary {
        try! makeDefaultLibrary(bundle: Bundle(for: Engine.self))
    }
}

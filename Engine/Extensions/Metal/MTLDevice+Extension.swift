//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

extension MTLDevice {
    // ====================
    // MTLDepthStencilState
    // ====================
    func makeDepthStencilStateGBufferRenderer() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .gBufferRenderer)
    }
    func makeDepthStencilStateSpotLightShadowRenderer() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .spotShadowRenderer)
    }
    func makeDepthStencilStateOmniLightShadowRenderer() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .omniShadowRenderer)
    }
    func makeDepthStencilStateDirectionalLightShadowRenderer() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .directionalShadowRenderer)
    }
    func makeDepthStencilStateEnvironmentRenderer() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .environmentRenderer)
    }
    func makeDepthStencilStateFogJob() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .fogJob)
    }
    func makeDepthStencilStateOmniPass() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .omniRenderer)
    }
    func makeDepthStencilStateDirectionalPass() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .directionalRenderer)
    }
    func makeDepthStencilStateSpotPass() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .spotRenderer)
    }
    func makeDepthStencilStateAmbientPass() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .ambientRenderer)
    }
    // ======================
    // MTLRenderPipelineState
    // ======================
    func makeRenderPipelineStateVignette(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .vignette(library: library))
    }
    func makeRenderPipelineStateGrain(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .grain(library: library))
    }
    func makeRenderPipelineStateSpotLightShadow(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .spotShadow(library: library))
    }
    func makeRenderPipelineStateSpotLightShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .spotShadowAnimated(library: library))
    }
    func makeRenderPipelineStateDirectionalLightShadow(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .directionalShadow(library: library))
    }
    func makeRenderPipelineStateDirectionalLightShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .directionalShadowAnimated(library: library))
    }
    func makeRenderPipelineStateOmniLightShadow(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .omniShadow(library: library))
    }
    func makeRenderPipelineStateOmniLightShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .omniShadowAnimated(library: library))
    }
    func makeRenderPipelineStateEnvironmentRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .environment(library: library))
    }
    func makeRenderPipelineStateFogJob(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .fog(library: library))
    }
    func makeRenderPipelineStateGBufferRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .gBuffer(library: library))
    }
    func makeRenderPipelineStateGBufferAnimatedRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .gBufferAnimated(library: library))
    }
    func makeRenderPipelineStateOmniRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .omni(library: library))
    }
    func makeRenderPipelineStateDirectionalRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .directional(library: library))
    }
    func makeRenderPipelineStateSpotRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .spot(library: library))
    }
    func makeRenderPipelineStateAmbientRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .ambient(library: library))
    }
    func makeRenderPipelineStateSsao(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .ssao(library: library))
    }
    func makeRenderPipelineStateBloomSplit(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .bloomSplit(library: library))
    }
    func makeRenderPipelineStateBloomMerge(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .bloomMerge(library: library))
    }
    // ==========
    // MTLTexture
    // ==========
    func makeTextureLightenSceneDepthStencil(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .lightenSceneDepthStencil(size: size))
        return texture?.labeled("Lighten Scene Depth Stencil")
    }
    func makeTextureLightenSceneColor(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .lightenSceneColor(size: size))
        return texture?.labeled("Lighten Scene Color")
    }
    func makeTextureGBufferAR(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .gBufferAR(size: size))
        return texture?.labeled("GBuffer Albedo-Roughness")
    }
    func makeTextureGBufferNM(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .gBufferNM(size: size))
        return texture?.labeled("GBuffer Normal-Metallic")
    }
    func makeTextureGBufferPR(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .gBufferPR(size: size))
        return texture?.labeled("GBuffer Position-Reflectance")
    }
    func makeTextureGBufferDepthStencil(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .gBufferDepthStencil(size: size))
        return texture?.labeled("GBuffer Depth Stencil")
    }
    func makeTextureSpotLightShadowDepthStencil(size: CGSize, lightsCount: Int) -> MTLTexture? {
        let texture = makeTexture(descriptor: .spotShadowDS(size: size,
                                                            lightsCount: lightsCount))
        return texture?.labeled("Spot Light Shadow Depth Stencil")
    }
    func makeTextureDirectionalLightShadowDepthStencil(size: CGSize, lightsCount: Int) -> MTLTexture? {
        let texture = makeTexture(descriptor: .directionalShadowDS(size: size,
                                                                   lightsCount: lightsCount))
        return texture?.labeled("Directional Light Shadow Depth Stencil")
    }
    func makeTextureOmniLightShadowDepthStencil(size: CGSize, lightsCount: Int) -> MTLTexture? {
        let texture = makeTexture(descriptor: .omniShadowDS(size: size,
                                                            lightsCount: lightsCount))
        return texture?.labeled("Omni Light Shadow Depth Stencil")
    }
    func makeTextureSsao(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .ssaoColor(size: size))
        return texture?.labeled("SSAO Color")
    }
    func makeTextureBloomSplitColor(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .bloomSplitColor(size: size))
        return texture?.labeled("Bloom Split Color")
    }
    func makeTextureBloomMergeColor(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .bloomMergeColor(size: size))
        return texture?.labeled("Bloom Merge Color")
    }
    func makeTexturePostprocessColor(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .postprocessColor(size: size))
        return texture?.labeled("Postprocess Color")
    }
    public func makeSolidCubeTexture(color: simd_float4) -> MTLTexture? {
        assert(length(color) <= 2.001, "Color values must be in [0.0, 1.0] range")
        let descriptor = MTLTextureDescriptor.minimalSolidColorCube
        guard let texture = self.makeTexture(descriptor: descriptor) else {
            return nil
        }
        let region = MTLRegion(origin: .zero,
                               size: texture.size)
        let mapped = simd_uchar4(color * 255)
        let rawData = [simd_uchar4](repeating: mapped, count: 64)
        var failed = false
        rawData.withUnsafeBytes { ptr in
            guard let baseAddress = ptr.baseAddress else {
                failed = true
                return
            }
            for slice in 6.naturalExclusive {
                texture.replace(region: region,
                                mipmapLevel: 0,
                                slice: slice,
                                withBytes: baseAddress,
                                bytesPerRow: 32,
                                bytesPerImage: 256)
            }
        }
        return failed ? nil : texture
    }
    public func makeSolid2DTexture(color: simd_float4) -> MTLTexture? {
        assert(length(color) <= 2.001, "Color values must be in [0.0, 1.0] range")
        guard let texture = makeTexture(descriptor: .minimalSolidColor2D) else {
            return nil
        }
        let region = MTLRegion(origin: .zero,
                               size: texture.size)
        let mapped = simd_uchar4(color * 255)
        let rawData = [simd_uchar4](repeating: mapped, count: 64)
        var failed = false
        rawData.withUnsafeBytes { ptr in
            guard let baseAddress = ptr.baseAddress else {
                failed = true
                return
            }
            texture.replace(region: region,
                            mipmapLevel: 0,
                            withBytes: baseAddress,
                            bytesPerRow: 32)
        }
        return failed ? nil : texture
    }
    // ==========
    // MTLLibrary
    // ==========
    func makePorcelainLibrary() -> MTLLibrary? {
        let library = try? makeDefaultLibrary(bundle: Bundle.porcelain)
        return library?.labeled("Default Library")
    }
    // =========
    // MTLBuffer
    // =========
    func makeBuffer(data: Data) -> MTLBuffer? {
        guard let newBuffer = makeSharedBuffer(length: data.count) else {
            return nil
        }
        data.withUnsafeBytes { pointer in
            newBuffer.contents().copyBuffer(from: pointer)
        }
        return newBuffer
    }
    func makeBuffer(pointer: UnsafeRawBufferPointer,
                    options: MTLResourceOptions = []) -> MTLBuffer? {
        guard let baseAddress = pointer.baseAddress else {
            return nil
        }
        return makeBuffer(bytes: baseAddress, length: pointer.count, options: options)
    }
    func makeBuffer<T>(array: [T], options: MTLResourceOptions = []) -> MTLBuffer? {
        array.withUnsafeBytes { ptr in
            makeBuffer(pointer: ptr)
        }
    }
    func makeSharedBuffer(length: Int) -> MTLBuffer? {
        makeBuffer(length: length, options: [.storageModeShared])
    }
    func makeSharedBuffer(pointer: UnsafeRawBufferPointer) -> MTLBuffer? {
        makeBuffer(pointer: pointer, options: [.storageModeShared])
    }
    func makeSharedBuffer<T>(array: [T]) -> MTLBuffer? {
        makeBuffer(array: array, options: [.storageModeShared])
    }
}

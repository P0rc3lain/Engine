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
        try? makeRenderPipelineState(descriptor: .spotLightShadowRenderer(library: library))
    }
    func makeRenderPipelineStateSpotLightShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .spotLightShadowAnimatedRenderer(library: library))
    }
    func makeRenderPipelineStateDirectionalLightShadow(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .directionalLightShadowRenderer(library: library))
    }
    func makeRenderPipelineStateDirectionalLightShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .directionalLightShadowAnimatedRenderer(library: library))
    }
    func makeRenderPipelineStateOmniLightShadow(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .omniLightShadowRenderer(library: library))
    }
    func makeRenderPipelineStateOmniLightShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .omniLightShadowAnimatedRenderer(library: library))
    }
    func makeRenderPipelineStateEnvironmentRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .environmentRenderer(library: library))
    }
    func makeRenderPipelineStateFogJob(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .fogJob(library: library))
    }
    func makeRenderPipelineStateGBufferRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .gBufferRenderer(library: library))
    }
    func makeRenderPipelineStateGBufferAnimatedRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .gBufferAnimatedRenderer(library: library))
    }
    func makeRenderPipelineStateOmniRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .omniRenderer(library: library))
    }
    func makeRenderPipelineStateDirectionalRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .directionalRenderer(library: library))
    }
    func makeRenderPipelineStateSpotRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .spotRenderer(library: library))
    }
    func makeRenderPipelineStateAmbientRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .ambientRenderer(library: library))
    }
    func makeRenderPipelineStateSsao(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .ssaoRenderer(library: library))
    }
    func makeRenderPipelineStateBloomSplit(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .bloomSplitRenderer(library: library))
    }
    func makeRenderPipelineStateBloomMerge(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .bloomMergeRenderer(library: library))
    }
    // ==========
    // MTLTexture
    // ==========
    func makeTextureLightenSceneDepthStencil(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: .lightenSceneDepthStencil(size: size))
    }
    func makeTextureLightenSceneColor(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: .lightenSceneColor(size: size))
    }
    func makeTextureGBufferAR(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: .gBufferAR(size: size))
    }
    func makeTextureGBufferNM(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: .gBufferNM(size: size))
    }
    func makeTextureGBufferPR(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: .gBufferPR(size: size))
    }
    func makeTextureGBufferDepthStencil(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: .gBufferDepthStencil(size: size))
    }
    func makeTextureSpotLightShadowDepthStencil(size: CGSize, lightsCount: Int) -> MTLTexture? {
        makeTexture(descriptor: .spotLightShadowDepthStencil(size: size, lightsCount: lightsCount))
    }
    func makeTextureDirectionalLightShadowDepthStencil(size: CGSize, lightsCount: Int) -> MTLTexture? {
        makeTexture(descriptor: .directionalLightShadowDepthStencil(size: size, lightsCount: lightsCount))
    }
    func makeTextureOmniLightShadowDepthStencil(size: CGSize, lightsCount: Int) -> MTLTexture? {
        makeTexture(descriptor: .omniLightShadowDepthStencil(size: size, lightsCount: lightsCount))
    }
    func makeTextureSsao(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: .ssaoColor(size: size))
    }
    func makeTextureBloomSplitColor(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: .bloomSplitColor(size: size))
    }
    func makeTextureBloomMergeColor(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: .bloomMergeColor(size: size))
    }
    func makeTexturePostprocessColor(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: .postprocessColor(size: size))
    }
    public func makeSolidCubeTexture(color: simd_float4) -> MTLTexture? {
        assert(length(color) <= 2.001, "Color values must be in [0.0, 1.0] range")
        let descriptor = MTLTextureDescriptor.minimalSolidColorCube
        guard let texture = self.makeTexture(descriptor: descriptor) else {
            return nil
        }
        let size = MTLSize(width: texture.width,
                           height: texture.height,
                           depth: texture.depth)
        let region = MTLRegion(origin: .zero,
                               size: size)
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
        let size = MTLSize(width: texture.width,
                           height: texture.height,
                           depth: texture.depth)
        let region = MTLRegion(origin: .zero,
                               size: size)
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

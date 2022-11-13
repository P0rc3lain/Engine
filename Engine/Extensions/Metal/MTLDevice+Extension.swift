//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

extension MTLDevice {
    // ====================
    // MTLDepthStencilState
    // ====================
    func makeDSSGBuffer() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .gBuffer)
    }
    func makeDSSSpotShadow() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .spotShadow)
    }
    func makeDSSOmniLightShadow() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .omniShadow)
    }
    func makeDSSDirectionalLightShadow() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .directionalShadow)
    }
    func makeDSSEnvironment() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .environment)
    }
    func makeDSSFog() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .fog)
    }
    func makeDSSOmni() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .omni)
    }
    func makeDSSDirectional() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .directional)
    }
    func makeDSSSpot() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .spot)
    }
    func makeDSSAmbient() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .ambient)
    }
    func makeDSSTranslucent() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .translucent)
    }
    func makeDSSParticle() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: .particle)
    }
    // ======================
    // MTLRenderPipelineState
    // ======================
    func makeRPSParticle(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .particle(library: library))
    }
    func makeRPSSpotShadow(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .spotShadow(library: library))
    }
    func makeRPSSpotShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .spotShadowAnimated(library: library))
    }
    func makeRPSTranslucent(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .translucent(library: library))
    }
    func makeRPSTranslucentAnimated(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .translucentAnimated(library: library))
    }
    func makeRPSDirectionalShadow(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .directionalShadow(library: library))
    }
    func makeRPSDirectionalShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .directionalShadowAnimated(library: library))
    }
    func makeRPSOmniShadow(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .omniShadow(library: library))
    }
    func makeRPSOmniShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .omniShadowAnimated(library: library))
    }
    func makeRPSEnvironment(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .environment(library: library))
    }
    func makeRPSFog(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .fog(library: library))
    }
    func makeRPSGBuffer(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .gBuffer(library: library))
    }
    func makeRPSGBufferAnimated(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .gBufferAnimated(library: library))
    }
    func makeRPSOmni(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .omni(library: library))
    }
    func makeRPSDirectional(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .directional(library: library))
    }
    func makeRPSSpot(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .spot(library: library))
    }
    func makeRPSAmbient(library: MTLLibrary) -> MTLRenderPipelineState? {
        try? makeRenderPipelineState(descriptor: .ambient(library: library))
    }
    // =======================
    // MTLComputePipelineState
    // =======================
    func makeCPSBloomMerge(library: MTLLibrary) -> MTLComputePipelineState? {
        guard let function = library.makeFunction(name: "kernelBloomMerge") else {
            return nil
        }
        return try? makeComputePipelineState(function: function)
    }
    func makeCPSBloomSplit(library: MTLLibrary) -> MTLComputePipelineState? {
        guard let function = library.makeFunction(name: "kernelBloomSplit") else {
            return nil
        }
        return try? makeComputePipelineState(function: function)
    }
    func makeCPSSSAO(library: MTLLibrary) -> MTLComputePipelineState? {
        guard let function = library.makeFunction(name: "kernelSSAO") else {
            return nil
        }
        return try? makeComputePipelineState(function: function)
    }
    // ==========
    // MTLTexture
    // ==========
    func makeTextureLightenSceneDS(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .lightenSceneDS(size: size))
        return texture?.labeled("Lighten Scene Depth Stencil")
    }
    func makeTextureLightenSceneC(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .lightenSceneC(size: size))
        return texture?.labeled("Lighten Scene Color")
    }
    func makeTextureGBufferARC(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .gBufferARC(size: size))
        return texture?.labeled("GBuffer Albedo-Roughness")
    }
    func makeTextureGBufferNMC(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .gBufferNMC(size: size))
        return texture?.labeled("GBuffer Normal-Metallic")
    }
    func makeTextureGBufferPRC(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .gBufferPRC(size: size))
        return texture?.labeled("GBuffer Position-Reflectance")
    }
    func makeTextureGBufferDS(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .gBufferDS(size: size))
        return texture?.labeled("GBuffer Depth Stencil")
    }
    func makeTextureSpotShadowDS(size: CGSize, lightsCount: Int) -> MTLTexture? {
        let texture = makeTexture(descriptor: .spotShadowDS(size: size,
                                                            lightsCount: lightsCount))
        return texture?.labeled("Spot Light Shadow Depth Stencil")
    }
    func makeTextureDirectionalShadowDS(size: CGSize, lightsCount: Int) -> MTLTexture? {
        let texture = makeTexture(descriptor: .directionalShadowDS(size: size,
                                                                   lightsCount: lightsCount))
        return texture?.labeled("Directional Light Shadow Depth Stencil")
    }
    func makeTextureOmniShadowDS(size: CGSize, lightsCount: Int) -> MTLTexture? {
        let texture = makeTexture(descriptor: .omniShadowDS(size: size,
                                                            lightsCount: lightsCount))
        return texture?.labeled("Omni Light Shadow Depth Stencil")
    }
    func makeTextureSSAOC(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .ssaoC(size: size))
        return texture?.labeled("SSAO Color")
    }
    func makeTextureBloomSplitC(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .bloomSplitC(size: size))
        return texture?.labeled("Bloom Split Color")
    }
    public func makeTextureSolidCube(color: PNColor4) -> MTLTexture? {
        assertValid(color: color)
        let descriptor = MTLTextureDescriptor.solidCubeC
        guard let texture = makeTexture(descriptor: descriptor) else {
            assertionFailure("Texture creation has failed")
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
            for slice in 6.exclusiveON {
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
    public func makeTextureSolid2D(color: PNColor4) -> MTLTexture? {
        assertValid(color: color)
        guard let texture = makeTexture(descriptor: .solid2DC) else {
            assertionFailure("Texture creation has failed")
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
    func makeBuffer(data: Data,
                    options: MTLResourceOptions = []) -> MTLBuffer? {
        data.withUnsafeBytes { pointer in
            makeBuffer(pointer: pointer, options: options)
        }
    }
    func makeBuffer(pointer: UnsafeRawBufferPointer,
                    options: MTLResourceOptions = []) -> MTLBuffer? {
        guard let baseAddress = pointer.baseAddress else {
            assertionFailure("Could not retrieve base address of buffer")
            return nil
        }
        return makeBuffer(bytes: baseAddress, length: pointer.count, options: options)
    }
    func makeBuffer<T>(array: [T], options: MTLResourceOptions = []) -> MTLBuffer? {
        array.withUnsafeBytes { ptr in
            makeBuffer(pointer: ptr)
        }
    }
    func makeBufferShared(data: Data) -> MTLBuffer? {
        makeBuffer(data: data, options: [.storageModeShared])
    }
    func makeBufferShared(length: Int) -> MTLBuffer? {
        makeBuffer(length: length, options: [.storageModeShared])
    }
    func makeBufferShared(pointer: UnsafeRawBufferPointer) -> MTLBuffer? {
        makeBuffer(pointer: pointer, options: [.storageModeShared])
    }
    func makeBufferShared<T>(array: [T]) -> MTLBuffer? {
        makeBuffer(array: array, options: [.storageModeShared])
    }
}

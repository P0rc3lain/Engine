//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics
import Metal
import PNShared
import simd

extension MTLDevice {
    // ====================
    // MTLDepthStencilState
    // ====================
    func failOrMakeDepthStencilState(descriptor: MTLDepthStencilDescriptor) -> any MTLDepthStencilState {
        guard let state = makeDepthStencilState(descriptor: descriptor) else {
            fatalError("Coult not create depth stencil state")
        }
        return state
    }
    func makeDSSGBuffer() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .gBuffer)
    }
    func makeDSSSpotShadow() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .spotShadow)
    }
    func makeDSSOmniLightShadow() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .omniShadow)
    }
    func makeDSSDirectionalLightShadow() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .directionalShadow)
    }
    func makeDSSEnvironment() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .environment)
    }
    func makeDSSFog() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .fog)
    }
    func makeDSSOmni() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .omni)
    }
    func makeDSSDirectional() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .directional)
    }
    func makeDSSSpot() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .spot)
    }
    func makeDSSAmbient() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .ambient)
    }
    func makeDSSTranslucent() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .translucent)
    }
    func makeDSSParticle() -> MTLDepthStencilState {
        failOrMakeDepthStencilState(descriptor: .particle)
    }
    // ======================
    // MTLRenderPipelineState
    // ======================
    func failOrMakeRenderPipelineState(descriptor: MTLRenderPipelineDescriptor) -> any MTLRenderPipelineState {
        do {
            return try makeRenderPipelineState(descriptor: descriptor)
        } catch let error {
            fatalError("Coult not create render pipeline state, error \(error.localizedDescription)")
        }
    }
    func makeRPSParticle(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .particle(library: library))
    }
    func makeRPSSpotShadow(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .spotShadow(library: library))
    }
    func makeRPSSpotShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .spotShadowAnimated(library: library))
    }
    func makeRPSTranslucent(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .translucent(library: library))
    }
    func makeRPSTranslucentAnimated(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .translucentAnimated(library: library))
    }
    func makeRPSDirectionalShadow(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .directionalShadow(library: library))
    }
    func makeRPSDirectionalShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .directionalShadowAnimated(library: library))
    }
    func makeRPSOmniShadow(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .omniShadow(library: library))
    }
    func makeRPSOmniShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .omniShadowAnimated(library: library))
    }
    func makeRPSEnvironment(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .environment(library: library))
    }
    func makeRPSFog(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .fog(library: library))
    }
    func makeRPSGBuffer(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .gBuffer(library: library))
    }
    func makeRPSGBufferAnimated(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .gBufferAnimated(library: library))
    }
    func makeRPSOmni(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .omni(library: library,
                                                        settings: PNDefaults.shared.shaders.lighting.omniLighting))
    }
    func makeRPSDirectional(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .directional(library: library,
                                                               settings: PNDefaults.shared.shaders.lighting.directionalLighting))
    }
    func makeRPSSpot(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .spot(library: library))
    }
    func makeRPSAmbient(library: MTLLibrary) -> MTLRenderPipelineState {
        failOrMakeRenderPipelineState(descriptor: .ambient(library: library))
    }
    // =======================
    // MTLComputePipelineState
    // =======================
    func failOrMakeComputePipelineState(function computeFunction: any MTLFunction) -> any MTLComputePipelineState {
        do {
            return try makeComputePipelineState(function: computeFunction)
        } catch let error {
            fatalError("Coult not create compute pipeline state, error \(error.localizedDescription)")
        }
    }
    func makeCPSPostprocessMerge(library: MTLLibrary) -> MTLComputePipelineState {
        let function = library.failOrMakeFunction(name: "postprocessMerge")
        return failOrMakeComputePipelineState(function: function)
    }
    func makeCPSBloomSplit(library: MTLLibrary) -> MTLComputePipelineState {
        let bloomSettings = PNDefaults.shared.shaders.postprocess.bloom
        let values = MTLFunctionConstantValues
            .half(bloomSettings.luminanceAmplifier, index: kFunctionConstantIndexBloomAmplification)
            .half(bloomSettings.luminanceThreshold, index: kFunctionConstantIndexBloomThreshold)
        let function = library.failOrMakeFunction(name: "kernelBloomSplit", constantValues: values)
        return failOrMakeComputePipelineState(function: function)
    }
    func makeCPSSSAO(library: MTLLibrary) -> MTLComputePipelineState {
        let ssaoSettings = PNDefaults.shared.shaders.ssao
        let values = MTLFunctionConstantValues
            .int(ssaoSettings.sampleCount, index: kFunctionConstantIndexSSAOSampleCount)
            .int(ssaoSettings.noiseCount, index: kFunctionConstantIndexSSAONoiseCount)
            .float(ssaoSettings.bias, index: kFunctionConstantIndexSSAOBias)
            .half(ssaoSettings.power, index: kFunctionConstantIndexSSAOPower)
            .float(ssaoSettings.radius, index: kFunctionConstantIndexSSAORadius)
        let function = library.failOrMakeFunction(name: "kernelSSAO",
                                                  constantValues: values)
        return failOrMakeComputePipelineState(function: function)
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
    func makeTextureGBufferVelocity(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .gBufferVelocity(size: size))
        return texture?.labeled("GBuffer Velocity")
    }
    func makeTextureGBufferDS(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .gBufferDS(size: size))
        return texture?.labeled("GBuffer Depth Stencil")
    }
    func makeTextureSSAOC(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .ssaoC(size: size))
        return texture?.labeled("SSAO Color")
    }
    func makeTextureBloomSplitC(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .bloomSplitC(size: size))
        return texture?.labeled("Bloom Split Color")
    }
    func makeTexturePostprocessOutput(size: CGSize) -> MTLTexture? {
        let texture = makeTexture(descriptor: .postprocessOutput(size: size))
        return texture?.labeled("Postprocess Output Color")
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
    func failOrMakeDefaultLibrary(bundle: Bundle) -> any MTLLibrary {
        do {
            return try makeDefaultLibrary(bundle: bundle)
        } catch let error {
            fatalError("Coult not create default library, error \(error.localizedDescription)")
        }
    }
    func makePorcelainLibrary() -> MTLLibrary {
        let library = failOrMakeDefaultLibrary(bundle: .current)
        return library.labeled("Default Library")
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

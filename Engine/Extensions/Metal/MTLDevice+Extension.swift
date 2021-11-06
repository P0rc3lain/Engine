//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

extension MTLDevice {
    func makeDepthStencilStateGBufferRenderer() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: MTLDepthStencilDescriptor.gBufferRenderer)
    }
    func makeDepthStencilStateEnvironmentRenderer() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: MTLDepthStencilDescriptor.environmentRenderer)
    }
    func makeDepthStencilStateLightPass() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: MTLDepthStencilDescriptor.lightPassRenderer)
    }
    func makeDepthStencilStateDirectionalPass() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: MTLDepthStencilDescriptor.directionalRenderer)
    }
    func makeDepthStencilStateAmbientPass() -> MTLDepthStencilState? {
        makeDepthStencilState(descriptor: MTLDepthStencilDescriptor.ambientRenderer)
    }
    func makeRenderPipelineStatePostprocessor(library: MTLLibrary) -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor.postProcessor(library: library)
        return try? makeRenderPipelineState(descriptor: descriptor)
    }
    func makeRenderPipelineStateEnvironmentRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor.environmentRenderer(library: library)
        return try? makeRenderPipelineState(descriptor: descriptor)
    }
    func makeRenderPipelineStateGBufferRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor.gBufferRenderer(library: library)
        return try? makeRenderPipelineState(descriptor: descriptor)
    }
    func makeRenderPipelineStateGBufferAnimatedRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor.gBufferAnimatedRenderer(library: library)
        return try? makeRenderPipelineState(descriptor: descriptor)
    }
    func makeRenderPipelineStateLightRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor.lightRenderer(library: library)
        return try? makeRenderPipelineState(descriptor: descriptor)
    }
    func makeRenderPipelineStateDirectionalRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor.directionalRenderer(library: library)
        return try? makeRenderPipelineState(descriptor: descriptor)
    }
    func makeRenderPipelineStateAmbientRenderer(library: MTLLibrary) -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor.ambientRenderer(library: library)
        return try? makeRenderPipelineState(descriptor: descriptor)
    }
    func makeRenderPipelineStateSsao(library: MTLLibrary) -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor.ssaoRenderer(library: library)
        return try? makeRenderPipelineState(descriptor: descriptor)
    }
    func makeRenderPipelineStateBloomSplit(library: MTLLibrary) -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor.bloomSplitRenderer(library: library)
        return try? makeRenderPipelineState(descriptor: descriptor)
    }
    func makeRenderPipelineStateBloomMerge(library: MTLLibrary) -> MTLRenderPipelineState? {
        let descriptor = MTLRenderPipelineDescriptor.bloomMergeRenderer(library: library)
        return try? makeRenderPipelineState(descriptor: descriptor)
    }
    func makeTextureLightenSceneDepthStencil(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: MTLTextureDescriptor.lightenSceneDepthStencil(size: size))
    }
    func makeTextureLightenSceneColor(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: MTLTextureDescriptor.lightenSceneColor(size: size))
    }
    func makeTextureGBufferAR(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: MTLTextureDescriptor.gBufferAR(size: size))
    }
    func makeTextureGBufferNM(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: MTLTextureDescriptor.gBufferNM(size: size))
    }
    func makeTextureGBufferPR(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: MTLTextureDescriptor.gBufferPR(size: size))
    }
    func makeTextureGBufferDepthStencil(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: MTLTextureDescriptor.gBufferDepthStencil(size: size))
    }
    func makeTextureSsao(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: MTLTextureDescriptor.ssaoColor(size: size))
    }
    func makeTextureBloomSplitColor(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: MTLTextureDescriptor.bloomSplitColor(size: size))
    }
    func makeTextureBloomMergeColor(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: MTLTextureDescriptor.bloomMergeColor(size: size))
    }
    func makeTexturePostprocessColor(size: CGSize) -> MTLTexture? {
        makeTexture(descriptor: MTLTextureDescriptor.postprocessColor(size: size))
    }
    func makePorcelainLibrary() -> MTLLibrary? {
        try? makeDefaultLibrary(bundle: Bundle(for: Engine.self))
    }
    func makeSharedBuffer(length: Int) -> MTLBuffer? {
        makeBuffer(length: length, options: [.storageModeShared])
    }
    public func makeSolid2DTexture(color: simd_float4) -> MTLTexture? {
        assert(length(color) <= 2.001, "Color values must be in [0.0, 1.0] range")
        let descriptor = MTLTextureDescriptor.minimalSolidColor2D
        guard let texture = self.makeTexture(descriptor: descriptor) else {
            return nil
        }
        let origin = MTLOrigin(x: 0, y: 0, z: 0)
        let size = MTLSize(width: texture.width, height: texture.height, depth: texture.depth)
        let region = MTLRegion(origin: origin, size: size)
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
    func makeBuffer(data: Data) -> MTLBuffer? {
        guard let newBuffer = makeSharedBuffer(length: data.count) else {
            return nil
        }
        data.withUnsafeBytes { pointer in
            newBuffer.contents().copyBuffer(from: pointer)
        }
        return newBuffer
    }
    func makeBuffer(pointer: UnsafeRawBufferPointer, options: MTLResourceOptions = []) -> MTLBuffer? {
        guard let baseAddress = pointer.baseAddress else {
            return nil
        }
        return makeBuffer(bytes: baseAddress, length: pointer.count, options: options)
    }
    func makeSharedBuffer(pointer: UnsafeRawBufferPointer) -> MTLBuffer? {
        makeBuffer(pointer: pointer, options: [.storageModeShared])
    }
    func makeBuffer<T>(array: [T], options: MTLResourceOptions = []) -> MTLBuffer? {
        array.withUnsafeBytes { ptr in
            makeBuffer(pointer: ptr)
        }
    }
    func makeSharedBuffer<T>(array: [T]) -> MTLBuffer? {
        makeBuffer(array: array, options: [.storageModeShared])
    }
    public func makeSolidCubeTexture(color: simd_float4) -> MTLTexture? {
        assert(length(color) <= 2.001, "Color values must be in [0.0, 1.0] range")
        let descriptor = MTLTextureDescriptor.minimalSolidColorCube
        guard let texture = self.makeTexture(descriptor: descriptor) else {
            return nil
        }
        let origin = MTLOrigin(x: 0, y: 0, z: 0)
        let size = MTLSize(width: texture.width, height: texture.height, depth: texture.depth)
        let region = MTLRegion(origin: origin, size: size)
        let mapped = simd_uchar4(color * 255)
        let rawData = [simd_uchar4](repeating: mapped, count: 64)
        var failed = false
        rawData.withUnsafeBytes { ptr in
            guard let baseAddress = ptr.baseAddress else {
                failed = true
                return
            }
            for slice in 0 ..< 6 {
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
}

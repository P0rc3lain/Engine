//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLRenderCommandEncoder {
    func setVertexBytes<T: RawRepresentable, P>(value: P,
                                                index: T) where T.RawValue == UInt32 {
        withUnsafePointer(to: value) { ptr in
            setVertexBytes(ptr, length: MemoryLayout<P>.size, index: index)
        }
    }
    func setFragmentBytes<T: RawRepresentable, P>(value: P,
                                                  index: T) where T.RawValue == UInt32 {
        withUnsafePointer(to: value) { ptr in
            setFragmentBytes(ptr, length: MemoryLayout<P>.size, index: index)
        }
    }
    func setVertexBytes<T: RawRepresentable>(_ bytes: UnsafeRawPointer,
                                             length: Int,
                                             index: T) where T.RawValue == UInt32 {
        setVertexBytes(bytes, length: length, index: index.rawValue.int)
    }
    func setFragmentBytes<T: RawRepresentable>(_ bytes: UnsafeRawPointer,
                                               length: Int,
                                               index: T) where T.RawValue == UInt32 {
        setFragmentBytes(bytes, length: length, index: index.rawValue.int)
    }
    func setVertexBuffer<T: RawRepresentable>(_ buffer: MTLBuffer?,
                                              offset: Int,
                                              index: T) where T.RawValue == UInt32 {
        setVertexBuffer(buffer, offset: offset, index: index.rawValue.int)
    }
    func setVertexBuffer<T: RawRepresentable>(_ buffer: MTLBuffer?,
                                              index: T) where T.RawValue == UInt32 {
        setVertexBuffer(buffer, offset: 0, index: index.rawValue.int)
    }
    func setVertexBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: PNAnyDynamicBuffer<Z>?,
                                                 offset: Int,
                                                 index: T) where T.RawValue == UInt32 {
        setVertexBuffer(dynamicBuffer?.buffer, offset: offset, index: index)
    }
    func setVertexBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: PNAnyDynamicBuffer<Z>?,
                                                 index: T) where T.RawValue == UInt32 {
        setVertexBuffer(dynamicBuffer?.buffer, offset: 0, index: index)
    }
    func setVertexBuffer<T: RawRepresentable, Z>(_ staticBuffer: PNAnyStaticBuffer<Z>?,
                                                 index: T) where T.RawValue == UInt32 {
        setVertexBuffer(staticBuffer?.buffer, offset: 0, index: index)
    }
    func setVertexBuffer(_ buffer: MTLBuffer?, index: Int) {
        setVertexBuffer(buffer, offset: 0, index: index)
    }
    func setFragmentBuffer(_ buffer: MTLBuffer?, index: Int) {
        setFragmentBuffer(buffer, offset: 0, index: index)
    }
    func setFragmentBuffer<T: RawRepresentable>(_ buffer: MTLBuffer?,
                                                index: T) where T.RawValue == UInt32 {
        setFragmentBuffer(buffer, offset: 0, index: index)
    }
    func setFragmentBuffer<T: RawRepresentable>(_ buffer: MTLBuffer?,
                                                offset: Int,
                                                index: T) where T.RawValue == UInt32 {
        setFragmentBuffer(buffer, offset: offset, index: index.rawValue.int)
    }
    func setFragmentBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: PNAnyDynamicBuffer<Z>?,
                                                   offset: Int,
                                                   index: T) where T.RawValue == UInt32 {
        setFragmentBuffer(dynamicBuffer?.buffer, offset: offset, index: index.rawValue.int)
    }
    func setFragmentBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: PNAnyDynamicBuffer<Z>?,
                                                   index: T) where T.RawValue == UInt32 {
        setFragmentBuffer(dynamicBuffer?.buffer, offset: 0, index: index)
    }
    func setFragmentTextures(_ textures: [MTLTexture?],
                             range: ClosedRange<Int>) {
        setFragmentTextures(textures, range: Range(range))
    }
    func setFragmentTextures(_ textures: [MTLTexture?],
                             range: ClosedRange<UInt32>) {
        setFragmentTextures(textures, range: range.lowerBound.int ... range.upperBound.int)
    }
    func setFragmentTextures(_ textureProviders: [PNTextureProvider],
                             range: ClosedRange<UInt32>) {
        setFragmentTextures(textureProviders.map({ $0.texture }), range: range)
    }
    func setFragmentTexture<T: RawRepresentable>(_ texture: MTLTexture?,
                                                 index: T) where T.RawValue == UInt32 {
        setFragmentTexture(texture, index: index.rawValue.int)
    }
    func setFragmentTexture<T: RawRepresentable>(_ textureProvider: PNTextureProvider,
                                                 index: T) where T.RawValue == UInt32 {
        setFragmentTexture(textureProvider.texture, index: index.rawValue.int)
    }
    func drawIndexedPrimitives(submesh indexDraw: PNSubmesh, instanceCount: Int = 1) {
        guard let buffer = indexDraw.indexBuffer.buffer else {
            fatalError("Buffer not set")
        }
        drawIndexedPrimitives(type: indexDraw.primitiveType,
                              indexCount: indexDraw.indexCount,
                              indexType: indexDraw.indexType,
                              indexBuffer: buffer,
                              indexBufferOffset: indexDraw.indexBuffer.offset,
                              instanceCount: instanceCount)
    }
}

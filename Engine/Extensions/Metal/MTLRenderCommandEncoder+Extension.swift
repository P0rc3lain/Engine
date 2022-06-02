//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLRenderCommandEncoder {
    func setVertexBytes<T: RawRepresentable, P>(value: P, index: T) where T.RawValue == UInt32 {
        var tmp = value
        setVertexBytes(&tmp, length: MemoryLayout<P>.size, index: index)
    }
    func setFragmentBytes<T: RawRepresentable, P>(value: P, index: T) where T.RawValue == UInt32 {
        var tmp = value
        setFragmentBytes(&tmp, length: MemoryLayout<P>.size, index: index)
    }
    func setVertexBytes<T: RawRepresentable>(_ bytes: UnsafeRawPointer, length: Int, index: T) where T.RawValue == UInt32 {
        setVertexBytes(bytes, length: length, index: index.rawValue.int)
    }
    func setFragmentBytes<T: RawRepresentable>(_ bytes: UnsafeRawPointer, length: Int, index: T) where T.RawValue == UInt32 {
        setFragmentBytes(bytes, length: length, index: index.rawValue.int)
    }
    func setVertexBuffer<T: RawRepresentable>(_ buffer: MTLBuffer?, offset: Int, index: T) where T.RawValue == UInt32 {
        setVertexBuffer(buffer, offset: offset, index: index.rawValue.int)
    }
    func setVertexBuffer<T: RawRepresentable>(_ buffer: MTLBuffer?, index: T) where T.RawValue == UInt32 {
        setVertexBuffer(buffer, offset: 0, index: index.rawValue.int)
    }
    func setVertexBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: PNAnyDynamicBuffer<Z>?, offset: Int, index: T) where T.RawValue == UInt32 {
        setVertexBuffer(dynamicBuffer?.buffer, offset: offset, index: index)
    }
    func setVertexBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: PNAnyDynamicBuffer<Z>?, index: T) where T.RawValue == UInt32 {
        setVertexBuffer(dynamicBuffer?.buffer, offset: 0, index: index)
    }
    func setVertexBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: PNAnyStaticBuffer<Z>?, index: T) where T.RawValue == UInt32 {
        setVertexBuffer(dynamicBuffer?.buffer, offset: 0, index: index)
    }
    func setVertexBuffer(_ buffer: MTLBuffer?, index: Int) {
        setVertexBuffer(buffer, offset: 0, index: index)
    }
    func setFragmentBuffer(_ buffer: MTLBuffer?, index: Int) {
        setFragmentBuffer(buffer, offset: 0, index: index)
    }
    func setFragmentBuffer<T: RawRepresentable>(_ buffer: MTLBuffer?, index: T) where T.RawValue == UInt32 {
        setFragmentBuffer(buffer, offset: 0, index: index)
    }
    func setFragmentBuffer<T: RawRepresentable>(_ buffer: MTLBuffer?, offset: Int, index: T) where T.RawValue == UInt32 {
        setFragmentBuffer(buffer, offset: offset, index: index.rawValue.int)
    }
    func setFragmentBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: PNAnyDynamicBuffer<Z>?, offset: Int, index: T) where T.RawValue == UInt32 {
        setFragmentBuffer(dynamicBuffer?.buffer, offset: offset, index: index.rawValue.int)
    }
    func setFragmentBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: PNAnyDynamicBuffer<Z>?, index: T) where T.RawValue == UInt32 {
        setFragmentBuffer(dynamicBuffer?.buffer, offset: 0, index: index)
    }
    func setFragmentTextures(_ textures: [MTLTexture?], range: ClosedRange<Int>) {
        setFragmentTextures(textures, range: Range(range))
    }
    func setFragmentTextures(_ textures: [MTLTexture?], range: ClosedRange<UInt32>) {
        setFragmentTextures(textures, range: range.lowerBound.int ... range.upperBound.int)
    }
    func setFragmentTexture<T: RawRepresentable>(_ texture: MTLTexture?, index: T) where T.RawValue == UInt32 {
        setFragmentTexture(texture, index: index.rawValue.int)
    }
    func setBackCulling(_ culling: PNCulling) {
        setCullMode(culling.backCulling)
        setFrontFacing(culling.winding)
    }
    func setFrontCulling(_ culling: PNCulling) {
        setCullMode(culling.frontCulling)
        setFrontFacing(culling.winding)
    }
    func drawIndexedPrimitives(submesh indexDraw: PNSubmesh, instanceCount: Int = 1) {
        drawIndexedPrimitives(type: indexDraw.primitiveType,
                              indexCount: indexDraw.indexCount,
                              indexType: indexDraw.indexType,
                              indexBuffer: indexDraw.indexBuffer.buffer,
                              indexBufferOffset: indexDraw.indexBuffer.offset,
                              instanceCount: instanceCount)
    }
}

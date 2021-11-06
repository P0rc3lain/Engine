//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLRenderCommandEncoder {
    func setVertexBytes<T: RawRepresentable>(_ bytes: UnsafeRawPointer, length: Int, index: T) where T.RawValue == UInt32 {
        setVertexBytes(bytes, length: length, index: Int(index.rawValue))
    }
    func setVertexBuffer<T: RawRepresentable>(_ buffer: MTLBuffer?, offset: Int, index: T) where T.RawValue == UInt32 {
        setVertexBuffer(buffer, offset: offset, index: Int(index.rawValue))
    }
    func setVertexBuffer<T: RawRepresentable>(_ buffer: MTLBuffer?, index: T) where T.RawValue == UInt32 {
        setVertexBuffer(buffer, offset: 0, index: Int(index.rawValue))
    }
    func setVertexBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: DynamicBuffer<Z>?, offset: Int, index: T) where T.RawValue == UInt32 {
        setVertexBuffer(dynamicBuffer?.buffer, offset: offset, index: index)
    }
    func setVertexBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: DynamicBuffer<Z>?, index: T) where T.RawValue == UInt32 {
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
        setFragmentBuffer(buffer, offset: offset, index: Int(index.rawValue))
    }
    func setFragmentBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: DynamicBuffer<Z>?, offset: Int, index: T) where T.RawValue == UInt32 {
        setFragmentBuffer(dynamicBuffer?.buffer, offset: offset, index: Int(index.rawValue))
    }
    func setFragmentBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: DynamicBuffer<Z>?, index: T) where T.RawValue == UInt32 {
        setFragmentBuffer(dynamicBuffer?.buffer, offset: 0, index: index)
    }
    func setFragmentTextures(_ textures: [MTLTexture?], range: ClosedRange<Int>) {
        setFragmentTextures(textures, range: Range(range))
    }
    func setFragmentTextures(_ textures: [MTLTexture?], range: ClosedRange<UInt32>) {
        setFragmentTextures(textures, range: Int(range.lowerBound) ... Int(range.upperBound))
    }
    func setFragmentTexture<T: RawRepresentable>(_ texture: MTLTexture?, index: T) where T.RawValue == UInt32 {
        setFragmentTexture(texture, index: Int(index.rawValue))
    }
}

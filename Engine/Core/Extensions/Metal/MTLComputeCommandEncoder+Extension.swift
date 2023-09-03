//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLComputeCommandEncoder {
    func setTexture<T: RawRepresentable>(_ provider: PNTextureProvider,
                                         index: T) where T.RawValue == UInt32 {
        setTexture(provider.texture, index: index.int)
    }
    func setBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: PNAnyDynamicBuffer<Z>?,
                                           offset: Int,
                                           index: T) where T.RawValue == UInt32 {
        setBuffer(dynamicBuffer?.buffer, offset: 0, index: index.int)
    }
    func setBuffer<T: RawRepresentable, Z>(_ dynamicBuffer: PNAnyDynamicBuffer<Z>?,
                                           index: T) where T.RawValue == UInt32 {
        setBuffer(dynamicBuffer, offset: 0, index: index)
    }
    func setBuffer<T: RawRepresentable, Z>(_ staticBuffer: PNAnyStaticBuffer<Z>?,
                                           index: T) where T.RawValue == UInt32 {
        setBuffer(staticBuffer?.buffer, offset: 0, index: index.int)
    }
    func setBytes<P, T: RawRepresentable>(_ value: P, index: T) where T.RawValue == UInt32 {
        withUnsafePointer(to: value) { ptr in
            setBytes(ptr, length: MemoryLayout<P>.size, index: index.int)
        }
    }
}

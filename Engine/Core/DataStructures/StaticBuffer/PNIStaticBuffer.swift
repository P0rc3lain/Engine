//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

final class PNIStaticBuffer<T>: PNStaticBuffer {
    typealias DataType = T
    private(set) var buffer: MTLBuffer
    init?(device: MTLDevice, capacity: Int) {
        assert(capacity > 0, "Buffer size must be greater than zero")
        let length = capacity * MemoryLayout<T>.stride
        guard let buffer = device.makeBufferShared(length: length) else {
            assertionFailure("Could not create buffer")
            return nil
        }
        self.buffer = buffer
        self.buffer.label = bufferName
    }
    func upload(data: [T]) {
        assert(data.count == buffer.length / MemoryLayout<T>.stride,
               "Sizes of allocated and provided buffers must match")
        data.withUnsafeBytes { pointer in
            buffer.contents().copyBuffer(from: pointer)
        }
    }
    func upload(value: T) {
        upload(data: [value])
    }
    private var bufferName: String {
        "\(Self.self)"
    }
}

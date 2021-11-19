//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

class PNIStaticBuffer<T>: PNStaticBuffer {
    typealias DataType = T
    private(set) var buffer: MTLBuffer
    init?(device: MTLDevice, capacity: Int) {
        assert(capacity > 0, "Buffer size must be greater than zero")
        guard let buffer = device.makeSharedBuffer(length: capacity * MemoryLayout<T>.stride) else {
            return nil
        }
        self.buffer = buffer
        self.buffer.label = bufferName
    }
    func upload(data: inout [T]) {
        assert(data.count == buffer.length / MemoryLayout<T>.stride,
               "Sizes of allocated and provided buffers must match")
        data.withUnsafeBytes { pointer in
            buffer.contents().copyBuffer(from: pointer)
        }
    }
    func upload(value: inout T) {
        var data = [value]
        upload(data: &data)
    }
    private var bufferName: String {
        "\(Self.self)"
    }
}

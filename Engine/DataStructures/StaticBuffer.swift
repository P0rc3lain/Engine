//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public struct StaticBuffer<T> {
    var buffer: MTLBuffer
    init?(device: MTLDevice, capacity: Int) {
        assert(capacity > 0, "Buffer size must be greater than zero")
        guard let buffer = device.makeSharedBuffer(length: capacity * MemoryLayout<T>.stride) else {
            return nil
        }
        self.buffer = buffer
        self.buffer.label = bufferName
    }
    mutating func upload(data: inout [T]) {
        assert(data.count == buffer.length / MemoryLayout<T>.stride, "Buffers size must match")
        data.withUnsafeBytes { pointer in
            buffer.contents().copyBuffer(from: pointer)
        }
    }
    mutating func upload(value: inout T) {
        var data = [value]
        upload(data: &data)
    }
    private var bufferName: String {
        "\(Self.self)"
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public struct DynamicBuffer<T> {
    private let device: MTLDevice
    var buffer: MTLBuffer
    private(set) var count: Int
    var pulled: [T] {
        let pointer = buffer.contents().bindMemory(to: T.self, capacity: count)
        return [T](UnsafeBufferPointer(start: pointer, count: count))
    }
    init?(device: MTLDevice, initialCapacity: Int) {
        assert(initialCapacity >= 0, "Capacity must be a natural value")
        guard let buffer = device.makeSharedBuffer(length: max(initialCapacity, 1) * MemoryLayout<T>.stride) else {
            return nil
        }
        self.count = 0
        self.device = device
        self.buffer = buffer
        self.buffer.label = bufferName
    }
    mutating func upload(data: inout  [T]) {
        count = data.count
        let requiredSpace = data.count * MemoryLayout<T>.stride
        if buffer.length < requiredSpace {
            let newSize = 2 * max(requiredSpace, buffer.length)
            guard let newBuffer = device.makeSharedBuffer(length: newSize) else {
                fatalError("Cannot extend buffer size")
            }
            buffer = newBuffer
        }
        data.withUnsafeBytes { pointer in
            buffer.contents().copyBuffer(from: pointer)
        }
    }
    private var bufferName: String {
        "\(Self.self)"
    }
}

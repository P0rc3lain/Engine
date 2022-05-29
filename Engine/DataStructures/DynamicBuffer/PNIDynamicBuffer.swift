//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

final public class PNIDynamicBuffer<T>: PNDynamicBuffer {
    private let device: MTLDevice
    private(set) var buffer: MTLBuffer
    private(set) var count: Int
    var pulled: [T] {
        let pointer = buffer.contents().bindMemory(to: T.self, capacity: count)
        return [T](UnsafeBufferPointer(start: pointer, count: count))
    }
    private var bufferName: String {
        "\(Self.self)"
    }
    init?(device: MTLDevice, initialCapacity: Int = 0) {
        assert(initialCapacity >= 0, "Capacity must be a natural value")
        guard let buffer = device.makeBufferShared(length: max(initialCapacity, 1) * MemoryLayout<T>.stride) else {
            return nil
        }
        self.count = 0
        self.device = device
        self.buffer = buffer
        self.buffer.label = bufferName
    }
    func upload(data: inout [T]) {
        count = data.count
        let requiredSpace = data.count * MemoryLayout<T>.stride
        if buffer.length < requiredSpace {
            let newSize = 2 * max(requiredSpace, buffer.length)
            guard let newBuffer = device.makeBufferShared(length: newSize) else {
                fatalError("Cannot extend buffer size")
            }
            buffer = newBuffer
        }
        data.withUnsafeBytes { pointer in
            buffer.contents().copyBuffer(from: pointer)
        }
    }
}

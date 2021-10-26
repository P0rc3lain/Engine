//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public struct DynamicBuffer<T> {
    // MARK: - Properties
    private let device: MTLDevice
    var buffer: MTLBuffer
    // MARK: - Initialization
    init?(device: MTLDevice, initialCapacity: Int) {
        guard let buffer = device.makeSharedBuffer(length: initialCapacity * MemoryLayout<T>.stride) else {
            return nil
        }
        self.device = device
        self.buffer = buffer
        self.buffer.label = bufferName
    }
    // MARK: - Internal
    mutating func upload(data: inout  [T]) {
        let requiredSpace = data.count * MemoryLayout<T>.stride
        if buffer.length < requiredSpace {
            let newSize = 2 * max(requiredSpace, buffer.length)
            guard let newBuffer = device.makeSharedBuffer(length: newSize) else {
                fatalError("Cannot extend buffer size")
            }
            buffer = newBuffer
        }
        data.withUnsafeBytes { pointer in
            guard let baseAddress = pointer.baseAddress else {
                fatalError("Cannot upload data to the buffer")
            }
            buffer.contents().copyMemory(from: baseAddress, byteCount: pointer.count)
        }
    }
    // MARK: - Private
    private var bufferName: String {
        "\(Self.self)"
    }
}

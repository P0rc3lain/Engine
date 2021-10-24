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
            buffer = device.makeSharedBuffer(length: newSize)!
        }
        data.withUnsafeBytes { ptr in
            buffer.contents().copyMemory(from: ptr.baseAddress!, byteCount: ptr.count)
        }
    }
    // MARK: - Private
    private var bufferName: String {
        "\(Self.self)"
    }
}

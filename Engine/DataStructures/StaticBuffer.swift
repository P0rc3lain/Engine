//
//  StaticBuffer.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Metal

public struct StaticBuffer<T> {
    // MARK: - Properties
    var buffer: MTLBuffer
    // MARK: - Initialization
    init?(device: MTLDevice, capacity: Int) {
        guard let buffer = device.makeBuffer(length: Self.bytesCount(capacity), options: .storageModeShared) else {
            return nil
        }
        self.buffer = buffer
        self.buffer.label = bufferName
    }
    // MARK: - Internal
    mutating func upload(data: inout  [T]) {
        data.withUnsafeBytes { ptr in
            buffer.contents().copyMemory(from: ptr.baseAddress!, byteCount: ptr.count)
        }
    }
    // MARK: - Private
    private static func bytesCount(_ elementsCount: Int) -> Int {
        return elementsCount * MemoryLayout<T>.stride
    }
    private var bufferName: String {
        "\(Self.self)"
    }
}

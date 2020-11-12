//
//  SharedBuffer.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 11/11/2020.
//

import Metal

public struct SharedBuffer<T> {
    // MARK: - Properties
    private let device: MTLDevice
    var buffer: MTLBuffer
    // MARK: - Initialization
    init?(device: MTLDevice, initialCapacity: Int) {
        guard let buffer = device.makeBuffer(length: initialCapacity * MemoryLayout<T>.stride, options: [.storageModeShared]) else {
            return nil
        }
        self.device = device
        self.buffer = buffer
        self.buffer.label = bufferName
    }
    // MARK: - Internal
    func upload(data: inout  [T]) {
        if !willFit(elementsCount: data.count) {
            fatalError("Not implemented")
        }
        data.withUnsafeBytes { ptr in
            buffer.contents().copyMemory(from: ptr.baseAddress!, byteCount: ptr.count)
        }
    }
    // MARK: - Private
    private func bytesCount(_ elementsCount: Int) -> Int {
        return elementsCount * MemoryLayout<T>.stride
    }
    private func willFit(elementsCount: Int) -> Bool {
        return buffer.length >= bytesCount(elementsCount)
    }
    private var bufferName: String {
        "\(Self.self)<\(T.self)>"
    }
}

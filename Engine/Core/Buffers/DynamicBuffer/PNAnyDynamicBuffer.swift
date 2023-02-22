//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

/// Wrapper for ``PNDynamicBuffer``.
public struct PNAnyDynamicBuffer<T>: PNDynamicBuffer {
    public typealias DataType = T
    private let bufferRetriever: () -> MTLBuffer
    private let pulledValueRetriever: () -> [T]
    private let countRetriever: () -> Int
    private let uploadArray: ([T]) -> Void
    private let uploadValue: (T) -> Void
    public var buffer: MTLBuffer {
        bufferRetriever()
    }
    public var pulled: [T] {
        pulledValueRetriever()
    }
    public var count: Int {
        countRetriever()
    }
    public init<V: PNDynamicBuffer>(_ delegatee: V) where V.DataType == T {
        pulledValueRetriever = { delegatee.pulled }
        bufferRetriever = { delegatee.buffer }
        uploadArray = delegatee.upload(data:)
        countRetriever = { delegatee.count }
        uploadValue = delegatee.upload(data:)
    }
    public func upload(data: [T]) {
        uploadArray(data)
    }
    public func upload(data: T) {
        uploadValue(data)
    }
}

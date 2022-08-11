//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public struct PNAnyDynamicBuffer<T>: PNDynamicBuffer {
    typealias DataType = T
    private let bufferRetriever: () -> MTLBuffer
    private let pulledValueRetriever: () -> [T]
    private let countRetriever: () -> Int
    private let uploadArray: ([T]) -> Void
    private let uploadValue: (T) -> Void
    var buffer: MTLBuffer {
        bufferRetriever()
    }
    var pulled: [T] {
        pulledValueRetriever()
    }
    var count: Int {
        countRetriever()
    }
    init<V: PNDynamicBuffer>(_ delegatee: V) where V.DataType == T {
        pulledValueRetriever = { delegatee.pulled }
        bufferRetriever = { delegatee.buffer }
        uploadArray = delegatee.upload(data:)
        countRetriever = { delegatee.count }
        uploadValue = delegatee.upload(data:)
    }
    func upload(data: [T]) {
        uploadArray(data)
    }
    func upload(data: T) {
        uploadValue(data)
    }
}

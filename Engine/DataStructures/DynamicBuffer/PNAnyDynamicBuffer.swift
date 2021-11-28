//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public struct PNAnyDynamicBuffer<T>: PNDynamicBuffer {
    typealias DataType = T
    private let bufferRetriever: () -> MTLBuffer
    private let pulledValueRetriever: () -> [T]
    private let uploadArray: (inout [T]) -> Void
    var buffer: MTLBuffer {
        bufferRetriever()
    }
    var pulled: [T] {
        pulledValueRetriever()
    }
    init<V: PNDynamicBuffer>(_ delegatee: V) where V.DataType == T {
        pulledValueRetriever = { delegatee.pulled }
        bufferRetriever = { delegatee.buffer }
        uploadArray = delegatee.upload(data:)
    }
    func upload(data: inout [T]) {
        uploadArray(&data)
    }
}

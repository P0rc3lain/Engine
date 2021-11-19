//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

struct PNAnyStaticBuffer<T>: PNStaticBuffer {
    typealias DataType = T
    private let bufferRetriever: () -> MTLBuffer
    private let uploadArray: (inout [T]) -> Void
    private let uploadValue: (inout T) -> Void
    var buffer: MTLBuffer {
        bufferRetriever()
    }
    init<V: PNStaticBuffer>(_ delegatee: V) where V.DataType == T {
        bufferRetriever = { delegatee.buffer }
        uploadValue = delegatee.upload(value:)
        uploadArray = delegatee.upload(data:)
    }
    func upload(data: inout [T]) {
        uploadArray(&data)
    }
    func upload(value: inout T) {
        uploadValue(&value)
    }
}

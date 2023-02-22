//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

/// Variable-sized, stretchable buffer.
/// Behaves as a component type that carries an internal capacity of a certain number of elements.
/// Can allocate a heap memory block if the internal capacity is exhausted.
public protocol PNDynamicBuffer {
    associatedtype DataType
    var buffer: MTLBuffer { get }
    var pulled: [DataType] { get }
    var count: Int { get }
    func upload(data: [DataType])
    func upload(data: DataType)
}

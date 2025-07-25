//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

/// Variable-sized, stretchable buffer.
/// Behaves as a component type that carries an internal capacity of a certain number of elements.
/// Can allocate additional memory if the internal capacity is exhausted.
public protocol PNDynamicBuffer {
    /// The data type stored in the buffer.
    associatedtype DataType
    /// The underlying Metal buffer used to store the contents.
    var buffer: MTLBuffer { get }
    /// The most recent contents of the buffer, pulled as an array of `DataType`.
    /// This allows access to the contents as Swift types rather than raw GPU memory.
    var pulled: [DataType] { get }
    /// The number of valid elements currently stored in the buffer.
    var count: Int { get }
    /// Uploads a new array of data to the buffer, replacing its contents.
    /// If the internal buffer capacity is insufficient, allocates additional memory.
    /// - Parameter data: The array of data to upload.
    func upload(data: [DataType])
    /// Uploads a single data element to the buffer, appending or replacing contents according to implementation.
    /// May increase buffer capacity if needed.
    /// - Parameter data: The data element to upload.
    func upload(data: DataType)
}

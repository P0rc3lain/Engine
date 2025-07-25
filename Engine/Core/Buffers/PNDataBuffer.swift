//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

/// A fixed-size GPU buffer wrapper for use with Metal.
/// Provides an interface for buffer management with optional labeling.
public struct PNDataBuffer {
    /// The underlying Metal buffer. May be nil if allocation failed.
    public let buffer: MTLBuffer?
    /// The length, in bytes, of the buffer segment represented.
    public let length: Int
    /// The byte offset into the Metal buffer where this segment begins.
    public let offset: Int
    /// A descriptive label for identifying this buffer in debugging tools. Setting this will update the Metal buffer's label.
    public var label: String? {
        set {
            buffer?.label = newValue
        } get {
            buffer?.label
        }
    }
    /// Creates a PNDataBuffer using a given Metal buffer, byte length, offset, and optional label.
    /// - Parameters:
    ///   - buffer: The Metal buffer to wrap.
    ///   - length: The size, in bytes, of the buffer segment.
    ///   - offset: The offset in bytes where this segment starts. Defaults to 0.
    ///   - label: An optional debug label for the buffer.
    public init(buffer: MTLBuffer?, length: Int, offset: Int = 0, label: String? = nil) {
        self.buffer = buffer
        self.length = length
        self.offset = offset
        self.label = label
    }
    /// Convenience initializer for wrapping the entire Metal buffer as a PNDataBuffer.
    /// - Parameters:
    ///   - buffer: The Metal buffer to wrap.
    ///   - label: An optional debug label for the buffer.
    public init(wholeBuffer buffer: MTLBuffer?, label: String? = nil) {
        self.init(buffer: buffer,
                  length: buffer?.length ?? 0,
                  offset: buffer?.offset ?? 0,
                  label: label)
    }
}


//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public struct PNDataBuffer {
    public let buffer: MTLBuffer
    public let length: Int
    public let offset: Int
    public init(buffer: MTLBuffer, length: Int, offset: Int = 0) {
        self.buffer = buffer
        self.length = length
        self.offset = offset
    }
}

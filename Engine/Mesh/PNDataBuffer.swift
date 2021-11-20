//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNDataBuffer<DataType> {
    public let buffer: DataType
    public let length: Int
    public let offset: Int
    public init(buffer: DataType, length: Int, offset: Int = 0) {
        self.buffer = buffer
        self.length = length
        self.offset = offset
    }
}

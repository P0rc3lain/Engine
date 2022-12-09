//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public struct PNSubmesh {
    public let indexBuffer: PNDataBuffer
    public let indexCount: Int
    public let indexType: MTLIndexType
    public let primitiveType: MTLPrimitiveType
    public init(indexBuffer: PNDataBuffer,
                indexCount: Int,
                indexType: MTLIndexType,
                primitiveType: MTLPrimitiveType) {
        self.indexBuffer = indexBuffer
        self.indexCount = indexCount
        self.indexType = indexType
        self.primitiveType = primitiveType
    }
}

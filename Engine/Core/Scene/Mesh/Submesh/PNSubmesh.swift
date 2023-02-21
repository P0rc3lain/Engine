//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

/// Describes how to assemble a submesh by providing index buffer and assembly algorithm.
/// Relies of using external vertex buffer to fetch actual data.
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

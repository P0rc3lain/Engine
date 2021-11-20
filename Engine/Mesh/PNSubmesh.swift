//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNSubmesh<DataType, IndexType, GeometryType> {
    public let indexBuffer: PNDataBuffer<DataType>
    public let indexCount: Int
    public let indexType: IndexType
    public let primitiveType: GeometryType
    public init(indexBuffer: PNDataBuffer<DataType>,
                indexCount: Int,
                indexType: IndexType,
                primitiveType: GeometryType) {
        self.indexBuffer = indexBuffer
        self.indexCount = indexCount
        self.indexType = indexType
        self.primitiveType = primitiveType
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct IndexBasedDraw<DataType, IndexType, GeometryType> {
    public let indexBuffer: DataBuffer<DataType>
    public let indexCount: Int
    public let indexType: IndexType
    public let primitiveType: GeometryType
    public init(indexBuffer: DataBuffer<DataType>,
                indexCount: Int,
                indexType: IndexType,
                primitiveType: GeometryType) {
        self.indexBuffer = indexBuffer
        self.indexCount = indexCount
        self.indexType = indexType
        self.primitiveType = primitiveType
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct Geometry<DataType, IndexType, PrimitiveType> {
    public let vertexBuffer: DataBuffer<DataType>
    public let pieceDescriptions: [PieceDescription<DataType, IndexType, PrimitiveType>]
    public init(vertexBuffer: DataBuffer<DataType>,
                pieceDescriptions: [PieceDescription<DataType, IndexType, PrimitiveType>]) {
        self.vertexBuffer = vertexBuffer
        self.pieceDescriptions = pieceDescriptions
    }
}

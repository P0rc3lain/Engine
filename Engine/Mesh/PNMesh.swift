//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNMesh<DataType, IndexType, PrimitiveType>: Identifiable {
    public let name: String
    public let boundingBox: BoundingBox
    public let vertexBuffer: PNDataBuffer<DataType>
    public let pieceDescriptions: [PNPieceDescription<DataType, IndexType, PrimitiveType>]
    public init(name: String,
                boundingBox: BoundingBox,
                vertexBuffer: PNDataBuffer<DataType>,
                pieceDescriptions: [PNPieceDescription<DataType, IndexType, PrimitiveType>]) {
        self.name = name
        self.boundingBox = boundingBox
        self.vertexBuffer = vertexBuffer
        self.pieceDescriptions = pieceDescriptions
    }
}

//
//  Geometry.swift
//  Types
//
//  Created by Mateusz Stompór on 09/10/2021.
//

public struct Geometry<DataType, IndexType, PrimitiveType> {
    // MARK: - Properties
    public let vertexBuffer: DataBuffer<DataType>
    public let pieceDescriptions: [PieceDescription<DataType, IndexType, PrimitiveType>]
    // MARK: - Initialization
    public init(vertexBuffer: DataBuffer<DataType>,
                pieceDescriptions: [PieceDescription<DataType, IndexType, PrimitiveType>]) {
        self.vertexBuffer = vertexBuffer
        self.pieceDescriptions = pieceDescriptions
    }
}

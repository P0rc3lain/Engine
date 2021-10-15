//
//  PieceDescription.swift
//  Types
//
//  Created by Mateusz Stompór on 12/10/2021.
//

public struct PieceDescription<DataType, IndexType, GeometryType> {
    // MARK: - Properties
    public let materialIdx: Int
    public let drawDescription: IndexBasedDraw<DataType, IndexType, GeometryType>
    // MARK: - Initialization
    public init(materialIdx: Int,
                drawDescription: IndexBasedDraw<DataType, IndexType, GeometryType>) {
        self.materialIdx = materialIdx
        self.drawDescription = drawDescription
    }
}

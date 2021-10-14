//
//  PositionedPiece.swift
//  Engine
//
//  Created by Mateusz Stompór on 13/11/2020.
//

import Foundation

public struct PositionedPiece {
    // MARK: - Properties
    let pieceDescriptor: ModelPieceDescriptor
    public var coordinateSpace: CoordinateSpace
    // MARK: - Initialization
    public init(pieceDescriptor: ModelPieceDescriptor, coordinateSpace: CoordinateSpace) {
        self.pieceDescriptor = pieceDescriptor
        self.coordinateSpace = coordinateSpace
    }
}

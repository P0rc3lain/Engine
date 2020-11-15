//
//  PositionedPiece.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 13/11/2020.
//

import Foundation

public struct PositionedPiece {
    // MARK: - Properties
    var modelPiece: ModelPiece
    public var coordinateSpace: CoordinateSpace
    // MARK: - Initialization
    public init(modelPiece: ModelPiece, coordinateSpace: CoordinateSpace) {
        self.modelPiece = modelPiece
        self.coordinateSpace = coordinateSpace
    }
}

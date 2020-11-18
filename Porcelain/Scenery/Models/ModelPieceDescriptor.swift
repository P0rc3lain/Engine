//
//  ModelPieceDescriptor.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import Foundation

public struct ModelPieceDescriptor {
    // MARK: - Properties
    public let material: Int
    public let piece: GeometryPieceDescriptor
    // MARK: - Initialization
    public init(material: Int, piece: GeometryPieceDescriptor) {
        self.material = material
        self.piece = piece
    }
}

//
//  ModelPiece.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import Foundation

public struct ModelPiece {
    public let coordinateSpace: CoordinateSpace
    public let material: Material? = nil
    public let geometry: Geometry
    public init(coordinateSpace: CoordinateSpace, geometry: Geometry) {
        self.coordinateSpace = coordinateSpace
        self.geometry = geometry
    }
}

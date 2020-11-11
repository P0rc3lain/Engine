//
//  ModelPiece.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import Foundation

public struct ModelPiece {
    public let material: Material
    public let geometry: Geometry
    public init(material: Material, geometry: Geometry) {
        self.material = material
        self.geometry = geometry
    }
}

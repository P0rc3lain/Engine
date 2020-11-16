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
    public let geometry: Int
    // MARK: - Initialization
    public init(material: Int, geometry: Int) {
        self.material = material
        self.geometry = geometry
    }
}

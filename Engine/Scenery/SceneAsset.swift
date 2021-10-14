//
//  SceneAsset.swift
//  Engine
//
//  Created by Mateusz Stompór on 16/11/2020.
//

import Metal

public struct SceneAsset {
    // MARK: - Properties
    let materials: [Material]
    let geometries: [Geometry]
    let environment: MTLTexture
    // MARK: - Initialization
    public init(materials: [Material], geometries: [Geometry], environment: MTLTexture) {
        self.materials = materials
        self.geometries = geometries
        self.environment = environment
    }
}

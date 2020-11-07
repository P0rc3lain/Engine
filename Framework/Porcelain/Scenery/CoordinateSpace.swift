//
//  CoordinateSpace.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 06/11/2020.
//

import simd

public struct CoordinateSpace {
    // MARK: - Properties
    public var rotation: simd_quatf
    public var translation: simd_float3
    public var scale: simd_float3
    // MARK: - Initialization
    public init(rotation: simd_quatf = simd_quatf(), translation: simd_float3 = simd_float3(), scale: simd_float3 = simd_float3(repeating: 1)) {
        self.rotation = rotation
        self.translation = translation
        self.scale = scale
    }
}

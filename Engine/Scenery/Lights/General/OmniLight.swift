//
//  OmniLight.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import simd

public struct OmniLight {
    // MARK: - Properties
    public var color: simd_float3
    public var intensity: Float {
        didSet {
            if intensity < 0 {
                intensity = 0
            }
        }
    }
    public var position: simd_float3
    // MARK: - Initialization
    public init(color: simd_float3, intensity: Float, position: simd_float3) {
        assert(color.norm <= 1.733, "Color values must be in [0.0, 1.0] range")
        self.color = color
        self.intensity = intensity
        self.position = position
    }
}

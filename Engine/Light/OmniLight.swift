//
//  OmniLight.swift
//  Types
//
//  Created by Mateusz Stompór on 15/10/2021.
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
    public var idx: Int
    // MARK: - Initialization
    public init(color: simd_float3, intensity: Float, idx: Int) {
        assert(color.norm <= 1.733, "Color values must be in [0.0, 1.0] range")
        self.color = color
        self.intensity = intensity
        self.idx = idx
    }
}

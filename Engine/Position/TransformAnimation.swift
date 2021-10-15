//
//  TransformAnimation.swift
//  Types
//
//  Created by Mateusz Stompór on 11/10/2021.
//

import simd
import ModelIO

public struct TransformAnimation {
    // MARK: - Properties
    let scale: AnimatedFloat3
    let translation: AnimatedFloat3
    let rotation: AnimatedQuatf
    // MARK: - Initialization
    public init(scale: AnimatedFloat3, translation: AnimatedFloat3, rotation: AnimatedQuatf) {
        self.scale = scale
        self.translation = translation
        self.rotation = rotation
    }
    public init() {
        scale = .defaultScale
        translation = .defaultTranslation
        rotation = .defaultOrientation
    }
    func transformation(at time: TimeInterval) -> simd_float4x4 {
        return simd_float4x4.translation(vector: translation.interpolated(at: time)) *
               simd_float4x4(rotation.interpolated(at: time)) *
               simd_float4x4.scale(scale.interpolated(at: time))
    }
}

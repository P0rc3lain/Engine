//
//  SkeletalAnimation.swift
//  Engine
//
//  Created by Mateusz Stompór on 13/10/2021.
//

import simd
import ModelIO

public struct SkeletalAnimation {
    // MARK: - Properties
    public var translations: MDLAnimatedVector3Array
    public var rotations: MDLAnimatedQuaternionArray
    public var scales: MDLAnimatedVector3Array
    // MARK: - Initialization
    public init(translations: MDLAnimatedVector3Array,
                rotations: MDLAnimatedQuaternionArray,
                scales: MDLAnimatedVector3Array) {
        self.translations = translations
        self.rotations = rotations
        self.scales = scales
    }
    func localTransformation(at time: TimeInterval) -> [simd_float4x4] {
        var localTransformations = [simd_float4x4]()
        let translation = translations.float3Array(atTime: time)
        let rotation = rotations.floatQuaternionArray(atTime: time)
        let scale = scales.float3Array(atTime: time)
        for i in 0 ..< translations.elementCount {
            let composed = simd_float4x4.compose(translation: translation[i],
                                                 rotation: rotation[i],
                                                 scale: scale[i])
            localTransformations.append(composed)
        }
        return localTransformations
    }
}

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
}

//
//  Skeleton.swift
//  Engine
//
//  Created by Mateusz Stompór on 13/10/2021.
//

import simd

public struct Skeleton {
    // MARK: - Properties
    public var animationIdx: Int
    public var geometryBindTransform: simd_float4x4
    public var bindTransforms: [simd_float4x4]
    public var parentIndices: [Int]
    // MARK: - Initialization
    public init(animationIdx: Int, geometryBindTransform: simd_float4x4,
                bindTransforms: [simd_float4x4], parentIndices: [Int]) {
        self.animationIdx = animationIdx
        self.bindTransforms = bindTransforms
        self.parentIndices = parentIndices
        self.geometryBindTransform = geometryBindTransform
    }
}

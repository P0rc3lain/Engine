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
    // World coordinates
    public var bindTransforms: [simd_float4x4]
    public var inverseBindTransforms: [simd_float4x4]
    public var parentIndices: [Int]
    // MARK: - Initialization
    public init(animationIdx: Int,
                localBindTransforms: [simd_float4x4],
                parentIndices: [Int]) {
        assert(parentIndices.count == localBindTransforms.count, "Each transform must have a reference to its parent")
        self.animationIdx = animationIdx
        self.bindTransforms = Skeleton.computeWorldBindTransforms(localBindTransform: localBindTransforms,
                                                                  parentIndices: parentIndices)
        self.inverseBindTransforms = bindTransforms.map { $0.inverse }
        self.parentIndices = parentIndices
    }
    static func computeWorldBindTransforms(localBindTransform: [simd_float4x4],
                                           parentIndices: [Int]) -> [simd_float4x4] {
        var worldTransforms = [simd_float4x4]()
        for i in 0 ..< localBindTransform.count {
            let parentTransform = parentIndices[i] == .nil ? matrix_identity_float4x4 : worldTransforms[i]
            worldTransforms.append(parentTransform * localBindTransform[i])
        }
        return worldTransforms
    }
}

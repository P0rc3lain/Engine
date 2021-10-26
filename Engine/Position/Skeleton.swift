//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct Skeleton {
    // MARK: - Properties
    // World coordinates
    public var bindTransforms: [simd_float4x4]
    public var inverseBindTransforms: [simd_float4x4]
    public var parentIndices: [Int]
    // MARK: - Initialization
    public init(localBindTransforms: [simd_float4x4],
                parentIndices: [Int]) {
        assert(parentIndices.count == localBindTransforms.count, "Each transform must have a reference to its parent")
        self.bindTransforms = Skeleton.computeWorldBindTransforms(localBindTransform: localBindTransforms,
                                                                  parentIndices: parentIndices)
        self.inverseBindTransforms = bindTransforms.map { $0.inverse }
        self.parentIndices = parentIndices
    }
    func computeWorldBindTransforms(localBindTransform: [simd_float4x4]) -> [simd_float4x4] {
        Skeleton.computeWorldBindTransforms(localBindTransform: localBindTransform, parentIndices: parentIndices)
    }
    static func computeWorldBindTransforms(localBindTransform: [simd_float4x4],
                                           parentIndices: [Int]) -> [simd_float4x4] {
        assert(localBindTransform.count == parentIndices.count)
        var worldTransforms = [simd_float4x4]()
        for i in 0 ..< localBindTransform.count {
            let parentTransform = parentIndices[i] == .nil ? matrix_identity_float4x4 : worldTransforms[parentIndices[i]]
            worldTransforms.append(parentTransform * localBindTransform[i])
        }
        return worldTransforms
    }
}

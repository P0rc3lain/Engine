//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

struct PNISkeleton: PNSkeleton {
    var bindTransforms: [B2MTransform]
    var inverseBindTransforms: [M2BTransform]
    var animations: [PNAnimatedSkeleton]
    var parentIndices: [PNIndex]
    init(bindTransforms: [BLTransform],
         parentIndices: [Int],
         animations: [PNAnimatedSkeleton]) {
        assert(parentIndices.count == bindTransforms.count,
               "Each transform must have a reference to its parent")
        self.bindTransforms = PNISkeleton.computeBindTransforms(bindTransforms: bindTransforms,
                                                                parentIndices: parentIndices)
        self.inverseBindTransforms = bindTransforms.map { $0.inverse }
        self.animations = animations
        self.parentIndices = parentIndices
    }
    func calculatePose(animationPose: [BLTransform]) -> [B2MTransform] {
        let pose = PNISkeleton.computeBindTransforms(bindTransforms: animationPose,
                                                     parentIndices: parentIndices)
        return bindTransforms.indices.map { index in
            pose[index] * inverseBindTransforms[index]
        }
    }
    private static func computeBindTransforms(bindTransforms: [BLTransform],
                                              parentIndices: [PNIndex]) -> [B2MTransform] {
        assert(bindTransforms.count == parentIndices.count,
               "There must be a parent index assigned to each transform")
        var transforms = [B2MTransform]()
        for index in bindTransforms.indices {
            let parentTransform = parentIndices[index] == .nil ? matrix_identity_float4x4 : transforms[parentIndices[index]]
            transforms.append(parentTransform * bindTransforms[index])
        }
        return transforms
    }
}

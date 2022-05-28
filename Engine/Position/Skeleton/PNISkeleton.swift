//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

struct PNISkeleton: PNSkeleton {
    var bindTransforms: [PNB2MTransform]
    var inverseBindTransforms: [PNM2BTransform]
    var animations: [PNAnimatedSkeleton]
    var parentIndices: [PNIndex]
    init(bindTransforms: [PNBLTransform],
         parentIndices: [PNIndex],
         animations: [PNAnimatedSkeleton]) {
        assert(parentIndices.count == bindTransforms.count,
               "Each transform must have a reference to its parent")
        self.bindTransforms = PNISkeleton.computeBindTransforms(bindTransforms: bindTransforms,
                                                                parentIndices: parentIndices)
        self.inverseBindTransforms = bindTransforms.map { $0.inverse }
        self.animations = animations
        self.parentIndices = parentIndices
    }
    func calculatePose(animationPose: [PNBLTransform]) -> [PNB2MTransform] {
        let pose = PNISkeleton.computeBindTransforms(bindTransforms: animationPose,
                                                     parentIndices: parentIndices)
        return bindTransforms.indices.map { index in
            pose[index] * inverseBindTransforms[index]
        }
    }
    private static func computeBindTransforms(bindTransforms: [PNBLTransform],
                                              parentIndices: [PNIndex]) -> [PNB2MTransform] {
        assert(bindTransforms.count == parentIndices.count,
               "There must be a parent index assigned to each transform")
        var transforms = [PNB2MTransform]()
        for index in bindTransforms.indices {
            let parentTransform = parentIndices[index] == .nil ? matrix_identity_float4x4 : transforms[parentIndices[index]]
            transforms.append(parentTransform * bindTransforms[index])
        }
        return transforms
    }
}

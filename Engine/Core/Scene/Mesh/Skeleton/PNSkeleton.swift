//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Defines list of bones and their transforms.
/// Establishes hierarchy between them.
/// Contains all animations delivered along with the skeleton.
public protocol PNSkeleton {
    var bindTransforms: [PNB2MTransform] { get }
    var inverseBindTransforms: [PNM2BTransform] { get }
    var parentIndices: [PNIndex] { get }
    var animations: [PNAnimatedSkeleton] { get }
    func calculatePose(animationPose: [PNBLTransform]) -> [PNB2MTransform]
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNSkeleton {
    var bindTransforms: [B2MTransform] { get }
    var inverseBindTransforms: [M2BTransform] { get }
    var parentIndices: [Index] { get }
    var animations: [PNAnimatedSkeleton] { get }
    func calculatePose(animationPose: [BLTransform]) -> [B2MTransform]
}

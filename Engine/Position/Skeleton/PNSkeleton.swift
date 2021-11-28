//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNSkeleton {
    var bindTransforms: [PNB2MTransform] { get }
    var inverseBindTransforms: [PNM2BTransform] { get }
    var parentIndices: [PNIndex] { get }
    var animations: [PNAnimatedSkeleton] { get }
    func calculatePose(animationPose: [PNBLTransform]) -> [PNB2MTransform]
}

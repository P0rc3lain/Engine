//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension AnimatedQuatfArray {
    func interpolated(at time: TimeInterval) -> [simd_quatf] {
        let result = sample(at: time)
        return result.currentKeyFrame.indices.map {
            simd_slerp(result.currentKeyFrame[$0], result.upcomingKeyFrame[$0], result.ratio)
        }
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension AnimatedFloat3Array {
    func interpolated(at time: TimeInterval) -> [simd_float3] {
        let result = sample(at: time)
        return result.currentKeyFrame.indices.map {
            mix(result.currentKeyFrame[$0], result.upcomingKeyFrame[$0], t: result.ratio)
        }
    }
}

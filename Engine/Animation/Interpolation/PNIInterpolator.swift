//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

struct PNIInterpolator: PNInterpolator {
    func interpolated(sample result: PNAnimationSample<[simd_quatf]>) -> [simd_quatf] {
        result.currentKeyFrame.indices.map {
            simd_slerp(result.currentKeyFrame[$0],
                       result.upcomingKeyFrame[$0],
                       result.ratio)
        }
    }
    func interpolated(sample result: PNAnimationSample<[simd_float3]>) -> [simd_float3] {
        result.currentKeyFrame.indices.map {
            mix(result.currentKeyFrame[$0],
                result.upcomingKeyFrame[$0],
                t: result.ratio)
        }
    }
    func interpolated(sample result: PNAnimationSample<simd_quatf>) -> simd_quatf {
        simd_slerp(result.currentKeyFrame,
                   result.upcomingKeyFrame,
                   result.ratio)
    }
    func interpolated(sample result: PNAnimationSample<simd_float3>) -> simd_float3 {
        mix(result.currentKeyFrame,
            result.upcomingKeyFrame,
            t: result.ratio)
    }
}

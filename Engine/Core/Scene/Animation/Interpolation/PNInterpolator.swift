//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Purpose of the interpolator is to produce a single result that is mix of all provided input values
public protocol PNInterpolator {
    func interpolated(sample: PNAnimationSample<simd_quatf>) -> simd_quatf
    func interpolated(sample: PNAnimationSample<simd_float3>) -> simd_float3
    func interpolated(sample: PNAnimationSample<[simd_quatf]>) -> [simd_quatf]
    func interpolated(sample: PNAnimationSample<[simd_float3]>) -> [simd_float3]
}

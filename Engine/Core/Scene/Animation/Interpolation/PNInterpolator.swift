//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNInterpolator {
    func interpolated(sample: PNAnimationSample<simd_quatf>) -> simd_quatf
    func interpolated(sample: PNAnimationSample<simd_float3>) -> simd_float3
    func interpolated(sample: PNAnimationSample<[simd_quatf]>) -> [simd_quatf]
    func interpolated(sample: PNAnimationSample<[simd_float3]>) -> [simd_float3]
}

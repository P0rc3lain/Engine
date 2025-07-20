//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

protocol PNSSAOHemisphere {
    func noise(count: Int) -> [simd_float3]
    func samples(size: Int, radius: Float) -> [simd_float3]
}

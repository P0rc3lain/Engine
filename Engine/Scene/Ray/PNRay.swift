//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

struct PNRay {
    let origin: simd_float3
    let direction: simd_float3
    let inverseDirection: simd_float3
    init(origin: simd_float3, direction: simd_float3) {
        self.origin = origin
        self.direction = direction
        self.inverseDirection = 1 / direction
    }
}

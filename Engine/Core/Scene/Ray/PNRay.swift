//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

/// A part of a line that has a fixed starting point but no endpoint.
public struct PNRay {
    public let origin: simd_float3
    public let direction: simd_float3
    let inverseDirection: simd_float3
    public init(origin: simd_float3, direction: simd_float3) {
        assertUnit(vector: direction, allowedError: 0.01)
        self.origin = origin
        self.direction = direction
        self.inverseDirection = 1 / direction
    }
}

func * (_ lhs: simd_float4x4, _ rhs: PNRay) -> PNRay {
    var ldir = simd_float3x3(lhs.rotation) * rhs.direction
    ldir.normalize()
    let lori = lhs * simd_float4(rhs.origin, 1)
    return PNRay(origin: lori.xyz, direction: ldir)
}

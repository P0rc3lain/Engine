//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNRay {
    public let origin: simd_float3
    public let direction: simd_float3
    let inverseDirection: simd_float3
    public init(origin: simd_float3, direction: simd_float3) {
        self.origin = origin
        self.direction = direction
        self.inverseDirection = 1 / direction
    }
}

public func * (_ lhs: simd_float4x4, _ rhs: PNRay) -> PNRay {
    let ldir = lhs * simd_float4(rhs.direction, 1)
    let lori = lhs * simd_float4(rhs.origin, 1)
    return PNRay(origin: lori.xyz, direction: ldir.xyz)
}

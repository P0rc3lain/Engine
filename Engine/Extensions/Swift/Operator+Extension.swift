//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

func ... <T: RawRepresentable>(lhs: T, rhs: T) -> ClosedRange<T.RawValue> where T.RawValue == UInt32 {
    lhs.rawValue ... rhs.rawValue
}

func * (lhs: simd_float4x4, rhs: BoundingBox) -> BoundingBox {
    var output = [simd_float3](minimalCapacity: 8)
    for i in 8.naturalExclusive {
        var result = lhs * simd_float4(rhs.corners[i], 1)
        result.x /= result.w
        result.y /= result.w
        result.z /= result.w
        output.append(result.xyz)
    }
    return BoundingBox(corners: output)
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension simd_float3x3 {
    public static var identity: simd_float3x3 {
        matrix_identity_float3x3
    }
    public static func from(directionVector binormal: simd_float3) -> simd_float3x3 {
        assertEqual(length(binormal), 1)
        var normal = simd_float3.random().normalized
        normal = (normal - dot(binormal, normal) * binormal).normalized
        let tangent = cross(normal, binormal).normalized
        assert(dot(normal, binormal) == 0)
        assert(dot(tangent, binormal) == 0)
        return simd_float3x3(tangent, normal, -binormal)
    }
    public var expanded: simd_float4x4 {
        simd_float4x4(simd_float4(columns.0, 0),
                      simd_float4(columns.1, 0),
                      simd_float4(columns.2, 0),
                      simd_float4(.zero, 1))
    }
}

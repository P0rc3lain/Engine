//
//  Projection.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 06/11/2020.
//

import simd

extension matrix_float4x4 {
    static func perspectiveProjectionRightHand(fovyRadians: simd_float1, aspect: simd_float1, nearZ: simd_float1, farZ: simd_float1) -> matrix_float4x4 {
        let ys = 1 / tan(fovyRadians * 0.5)
        let xs = ys / aspect
        let zs = farZ / (nearZ - farZ);
        return matrix_float4x4.init(rows:[simd_float4(xs, 0,  0, 0),
                                          simd_float4(0, ys, 0, 0),
                                          simd_float4(0,  0, zs, nearZ * zs),
                                          simd_float4(0,  0, -1, 0 )])
    }
    static func translation(vector: simd_float3) -> matrix_float4x4 {
        return matrix_float4x4.init(rows:[simd_float4(0,  0, 0, 0),
                                          simd_float4(0,  0, 0, 0),
                                          simd_float4(0,  0, 0, 0),
                                          simd_float4(vector, 0)])
    }
}

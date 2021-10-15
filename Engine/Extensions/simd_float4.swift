//
//  simd_float4.swift
//  Types
//
//  Created by Mateusz Stompór on 10/10/2021.
//

import simd

extension simd_float4 {
    // MARK: - Public
    public var xyz: simd_float3 {
        simd_float3(x, y, z)
    }
    static var deafultNormalsColor: simd_float4 {
        simd_float4(1, 0.5, 0.5, 1)
    }
    static var deafultBaseColor: simd_float4 {
        simd_float4(0, 1, 0, 1)
    }
    static var deafultRoughnessColor: simd_float4 {
        simd_float4(1, 1, 1, 1)
    }
    static var defaultMetallicColor: simd_float4 {
        simd_float4(0, 0, 0, 1)
    }
}

//
//  simd_float4.swift
//  Engine
//
//  Created by Mateusz Stompór on 12/11/2020.
//

import simd

extension simd_float4 {
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

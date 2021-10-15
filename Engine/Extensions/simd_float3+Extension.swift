//
//  simd_float3.swift
//  Types
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import simd

extension simd_float3 {
    public var norm: Float {
        sqrtf(dot(self, self))
    }
}

//
//  simd_float3.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import simd

extension simd_float3 {
    var norm: Float {
        sqrtf(dot(self, self))
    }
}

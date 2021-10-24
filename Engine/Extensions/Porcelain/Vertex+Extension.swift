//
//  Vertex+Extension.swift
//  Vertex+Extension
//
//  Created by Mateusz Stompór on 20/10/2021.
//

import simd
import MetalBinding

extension Vertex {
    init(position: simd_float3, normal: simd_float3, tangent: simd_float3, textureUV: simd_float2) {
        self.init(position: position,
                  normal: normal,
                  tangent: tangent,
                  textureUV: textureUV,
                  jointIndices: .zero,
                  jointWeights: .zero)
    }
}

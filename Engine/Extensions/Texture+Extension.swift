//
//  Texture+Extension.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import simd

extension Texture {
    static func solid2D(color: simd_float4) -> Texture {
        return Texture(data: Data.solid2DTexture(color: color),
                       dimensions: simd_int2(8, 8),
                       rowStride: 8,
                       channelCount: 3,
                       channelEncoding: .float32,
                       isCube: false,
                       mipLevelCount: 0)
    }
}

//
//  MTLTextureDescriptor.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import simd
import Metal

extension MTLTextureDescriptor {
    static func solid(color: simd_float4,
                      pixelFormat: MTLPixelFormat = .bgra8Unorm) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.width = 1
        descriptor.height = 1
        descriptor.mipmapLevelCount = 1
        descriptor.storageMode = .private
        descriptor.pixelFormat = pixelFormat
        descriptor.textureType = .type2D
        descriptor.usage = .shaderRead
        return descriptor
    }
}

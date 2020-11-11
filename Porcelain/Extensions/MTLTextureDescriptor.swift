//
//  MTLTextureDescriptor.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 10/11/2020.
//

import simd
import Metal

extension MTLTextureDescriptor {
    static func singlePixel2D(pixelFormat: MTLPixelFormat = .bgra8Unorm) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.width = 1
        descriptor.height = 1
        descriptor.mipmapLevelCount = 1
        descriptor.storageMode = .managed
        descriptor.arrayLength = 1
        descriptor.sampleCount = 1
        descriptor.cpuCacheMode = .writeCombined
        descriptor.allowGPUOptimizedContents = false
        descriptor.pixelFormat = pixelFormat
        descriptor.textureType = .type2D
        descriptor.usage = .shaderRead
        return descriptor
    }
}

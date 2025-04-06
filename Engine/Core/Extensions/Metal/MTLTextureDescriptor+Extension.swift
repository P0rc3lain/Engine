//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import CoreGraphics
import Metal
import simd

extension MTLTextureDescriptor {
    static var solid2DC: MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.width = 8
        descriptor.height = 8
        descriptor.mipmapLevelCount = 1
        descriptor.storageMode = .shared
        descriptor.arrayLength = 1
        descriptor.sampleCount = 1
        descriptor.cpuCacheMode = .writeCombined
        descriptor.allowGPUOptimizedContents = false
        descriptor.pixelFormat = .bgra8Unorm
        descriptor.textureType = .type2D
        descriptor.usage = .shaderRead
        return descriptor
    }
    static var solidCubeC: MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.width = 8
        descriptor.height = 8
        descriptor.mipmapLevelCount = 1
        descriptor.storageMode = .shared
        descriptor.arrayLength = 1
        descriptor.sampleCount = 1
        descriptor.cpuCacheMode = .writeCombined
        descriptor.allowGPUOptimizedContents = false
        descriptor.pixelFormat = .bgra8Unorm
        descriptor.textureType = .typeCube
        descriptor.usage = .shaderRead
        return descriptor
    }
    private static func gBufferAttachment(size: CGSize,
                                          pixelFormat: MTLPixelFormat) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = size.width.int
        descriptor.height = size.height.int
        descriptor.storageMode = .private
        descriptor.pixelFormat = pixelFormat
        descriptor.usage = [.shaderRead, .renderTarget]
        return descriptor
    }
    static func gBufferARC(size: CGSize) -> MTLTextureDescriptor {
        // Mean to store albedo and roughness
        // 3 bytes for albedo and 1 for roughness
        gBufferAttachment(size: size, pixelFormat: .gBufferARC)
    }
    static func gBufferNMC(size: CGSize) -> MTLTextureDescriptor {
        // Mean to store normals and metallic
        // 3 bytes for normals and 1 for metallic
        gBufferAttachment(size: size, pixelFormat: .gBufferNMC)
    }
    static func gBufferPRC(size: CGSize) -> MTLTextureDescriptor {
        // Mean to store positions and reflectance
        // 3 bytes for positions and 1 for reflectance
        gBufferAttachment(size: size, pixelFormat: .gBufferPRC)
    }
    static func gBufferVelocity(size: CGSize) -> MTLTextureDescriptor {
        // Mean to store positions and reflectance
        // 3 bytes for positions and 1 for reflectance
        gBufferAttachment(size: size, pixelFormat: .gBufferVelocity)
    }
    static func gBufferDS(size: CGSize) -> MTLTextureDescriptor {
        gBufferAttachment(size: size, pixelFormat: .gBufferDS)
    }
    static func directionalShadowDS(size: simd_uint2,
                                    lightsCount: Int) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2DArray
        descriptor.width = size.x.int
        descriptor.height = size.y.int
        descriptor.arrayLength = lightsCount
        descriptor.storageMode = .private
        descriptor.pixelFormat = .directionalShadowDS
        descriptor.usage = [.shaderRead, .renderTarget]
        return descriptor
    }
    static func spotShadowDS(size: simd_uint2,
                             lightsCount: Int) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2DArray
        descriptor.width = size.x.int
        descriptor.height = size.y.int
        descriptor.arrayLength = lightsCount
        descriptor.storageMode = .private
        descriptor.pixelFormat = .spotShadowDS
        descriptor.usage = [.shaderRead, .renderTarget]
        return descriptor
    }
    static func omniShadowDS(size: simd_uint2,
                             lightsCount: Int) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .typeCubeArray
        descriptor.width = size.x.int
        descriptor.height = size.y.int
        descriptor.arrayLength = lightsCount
        descriptor.storageMode = .private
        descriptor.pixelFormat = .omniShadowDS
        descriptor.usage = [.shaderRead, .renderTarget]
        return descriptor
    }
    static func lightenSceneC(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = size.width.int
        descriptor.height = size.height.int
        descriptor.storageMode = .private
        descriptor.pixelFormat = .lightenSceneC
        descriptor.usage = [.shaderRead, .renderTarget, .shaderWrite]
        return descriptor
    }
    static func ssaoC(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = size.width.int
        descriptor.height = size.height.int
        descriptor.storageMode = .private
        descriptor.pixelFormat = .ssaoC
        descriptor.usage = [.shaderRead, .renderTarget, .shaderWrite]
        return descriptor
    }
    static func bloomSplitC(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = size.width.int
        descriptor.height = size.height.int
        descriptor.storageMode = .private
        descriptor.pixelFormat = .bloomSplitC
        descriptor.usage = [.renderTarget, .shaderRead, .shaderWrite]
        return descriptor
    }
    static func bloomOutput(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = size.width.int
        descriptor.height = size.height.int
        descriptor.storageMode = .private
        descriptor.pixelFormat = .bloomOutput
        descriptor.usage = [.renderTarget, .shaderWrite]
        return descriptor
    }
    static func lightenSceneDS(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = size.width.int
        descriptor.height = size.height.int
        descriptor.storageMode = .private
        descriptor.pixelFormat = .lightenSceneDS
        descriptor.usage = .renderTarget
        return descriptor
    }
}

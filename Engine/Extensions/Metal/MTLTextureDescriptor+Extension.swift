//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

extension MTLTextureDescriptor {
    static var minimalSolidColor2D: MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.width = 8
        descriptor.height = 8
        descriptor.mipmapLevelCount = 1
        descriptor.storageMode = .managed
        descriptor.arrayLength = 1
        descriptor.sampleCount = 1
        descriptor.cpuCacheMode = .writeCombined
        descriptor.allowGPUOptimizedContents = false
        descriptor.pixelFormat = .bgra8Unorm
        descriptor.textureType = .type2D
        descriptor.usage = .shaderRead
        return descriptor
    }
    static var minimalSolidColorCube: MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.width = 8
        descriptor.height = 8
        descriptor.mipmapLevelCount = 1
        descriptor.storageMode = .managed
        descriptor.arrayLength = 1
        descriptor.sampleCount = 1
        descriptor.cpuCacheMode = .writeCombined
        descriptor.allowGPUOptimizedContents = false
        descriptor.pixelFormat = .bgra8Unorm
        descriptor.textureType = .typeCube
        descriptor.usage = .shaderRead
        return descriptor
    }
    private static func gBufferAttachment(size: CGSize, pixelFormat: MTLPixelFormat) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = pixelFormat
        descriptor.usage = [.shaderRead, .renderTarget, .shaderWrite]
        return descriptor
    }
    static func gBufferAR(size: CGSize) -> MTLTextureDescriptor {
        // Mean to store albedo and roughness
        // 3 bytes for albedo and 1 for roughness
        gBufferAttachment(size: size, pixelFormat: .gBufferAR)
    }
    static func gBufferNM(size: CGSize) -> MTLTextureDescriptor {
        // Mean to store normals and metallic
        // 3 bytes for normals and 1 for metallic
        gBufferAttachment(size: size, pixelFormat: .gBufferNM)
    }
    static func gBufferPR(size: CGSize) -> MTLTextureDescriptor {
        // Mean to store positions and reflectance
        // 3 bytes for positions and 1 for reflectance
        gBufferAttachment(size: size, pixelFormat: .gBufferPR)
    }
    static func gBufferDepthStencil(size: CGSize) -> MTLTextureDescriptor {
        gBufferAttachment(size: size, pixelFormat: .gBufferDepthStencil)
    }
    static func spotLightShadowDepthStencil(size: CGSize, lightsCount: Int) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2DArray
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.arrayLength = lightsCount
        descriptor.storageMode = .private
        descriptor.pixelFormat = .spotShadowDepthStencil
        descriptor.usage = [.shaderRead, .renderTarget]
        return descriptor
    }
    static func lightenSceneColor(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = MTLPixelFormat.lightenSceneColor
        descriptor.usage = [.shaderRead, .renderTarget]
        return descriptor
    }
    static func ssaoColor(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = MTLPixelFormat.ssaoColor
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        return descriptor
    }
    static func bloomSplitColor(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = MTLPixelFormat.bloomSplitColor
        descriptor.usage = [.renderTarget, .shaderRead, .shaderWrite]
        return descriptor
    }
    static func bloomMergeColor(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = MTLPixelFormat.bloomMergeColor
        descriptor.usage = [.renderTarget, .shaderRead, .shaderWrite]
        return descriptor
    }
    static func lightenSceneDepthStencil(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = MTLPixelFormat.lightenSceneDepthStencil
        descriptor.usage = .renderTarget
        return descriptor
    }
    static func postprocessColor(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = MTLPixelFormat.postprocessorRendererColor
        descriptor.usage = [.renderTarget, .shaderRead, .shaderWrite]
        return descriptor
    }
}

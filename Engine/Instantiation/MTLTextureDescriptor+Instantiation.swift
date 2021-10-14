//
//  MTLTextureDescriptor+Instantiation.swift
//  Engine
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Metal

extension MTLTextureDescriptor {
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
}

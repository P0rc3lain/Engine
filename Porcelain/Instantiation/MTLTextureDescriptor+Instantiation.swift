//
//  MTLTextureDescriptor+Instantiation.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Metal

extension MTLTextureDescriptor {
    static func gBufferAR(size: CGSize) -> MTLTextureDescriptor {
        // Mean to store albedo and roughness
        // 3 bytes for albedo and 1 for roughness
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = .rgba32Float
        descriptor.usage = [.shaderRead, .renderTarget, .shaderWrite]
        return descriptor
    }
    static func gBufferNM(size: CGSize) -> MTLTextureDescriptor {
        // Mean to store normals and metallic
        // 3 bytes for normals and 1 for metallic
        gBufferAR(size: size)
    }
    static func gBufferPR(size: CGSize) -> MTLTextureDescriptor {
        // Mean to store normals and metallic
        // 3 bytes for normals and 1 for metallic
        gBufferAR(size: size)
    }
    static func gBufferDepthStencil(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = .depth32Float_stencil8
        descriptor.usage = [.renderTarget, .shaderRead, .shaderWrite]
        return descriptor
    }
    static func lightenSceneColor(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = .rgba32Float
        descriptor.usage = [.shaderRead, .renderTarget]
        return descriptor
    }
    static func lightenSceneDepthStencil(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = .depth32Float_stencil8
        descriptor.usage = .renderTarget
        return descriptor
    }
}

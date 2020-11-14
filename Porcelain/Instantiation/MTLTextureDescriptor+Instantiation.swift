//
//  MTLTextureDescriptor+Instantiation.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Metal

extension MTLTextureDescriptor {
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
    static func lightenSceneDepth(size: CGSize) -> MTLTextureDescriptor {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(size.width)
        descriptor.height = Int(size.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = .depth32Float
        descriptor.usage = .renderTarget
        return descriptor
    }
}

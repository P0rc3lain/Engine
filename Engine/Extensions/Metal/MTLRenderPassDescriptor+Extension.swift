//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLRenderPassDescriptor {
    static func lightenScene(device: MTLDevice, stencil: MTLTexture, depth: MTLTexture, size: CGSize) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].texture = device.makeTextureLightenSceneC(size: size)
        descriptor.colorAttachments[0].clearColor = MTLClearColor()
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.depthAttachment.texture = stencil
        descriptor.depthAttachment.storeAction = .store
        descriptor.depthAttachment.loadAction = .load
        descriptor.stencilAttachment.texture = depth
        descriptor.stencilAttachment.loadAction = .load
        descriptor.stencilAttachment.storeAction = .store
        return descriptor
    }
    static func gBuffer(device: MTLDevice, size: CGSize) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].texture = device.makeTextureGBufferARC(size: size)
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.colorAttachments[0].clearColor = MTLClearColor()
        descriptor.colorAttachments[1].loadAction = .clear
        descriptor.colorAttachments[1].texture = device.makeTextureGBufferNMC(size: size)
        descriptor.colorAttachments[1].clearColor = MTLClearColor()
        descriptor.colorAttachments[1].storeAction = .store
        descriptor.colorAttachments[2].loadAction = .clear
        descriptor.colorAttachments[2].texture = device.makeTextureGBufferPRC(size: size)
        descriptor.colorAttachments[2].clearColor = MTLClearColor()
        descriptor.colorAttachments[2].storeAction = .store
        let depthStencil = device.makeTextureGBufferDS(size: size)
        descriptor.depthAttachment.clearDepth = 1
        descriptor.depthAttachment.texture = depthStencil
        descriptor.depthAttachment.storeAction = .store
        descriptor.depthAttachment.loadAction = .clear
        descriptor.stencilAttachment.clearStencil = 0
        descriptor.stencilAttachment.texture = depthStencil
        descriptor.stencilAttachment.loadAction = .clear
        descriptor.stencilAttachment.storeAction = .store
        return descriptor
    }
    static func spotLightShadow(device: MTLDevice, texture: MTLTexture?) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.renderTargetArrayLength = texture?.arrayLength ?? 0
        descriptor.depthAttachment.clearDepth = 1
        descriptor.depthAttachment.texture = texture
        descriptor.depthAttachment.storeAction = .store
        descriptor.depthAttachment.loadAction = .clear
        return descriptor
    }
    static func directionalLightShadow(device: MTLDevice, texture: MTLTexture?) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.renderTargetArrayLength = texture?.arrayLength ?? 0
        descriptor.depthAttachment.clearDepth = 1
        descriptor.depthAttachment.texture = texture
        descriptor.depthAttachment.storeAction = .store
        descriptor.depthAttachment.loadAction = .clear
        return descriptor
    }
    static func omniLightShadow(device: MTLDevice, texture: MTLTexture?) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.renderTargetArrayLength = 6 * (texture?.arrayLength ?? 0)
        descriptor.depthAttachment.clearDepth = 1
        descriptor.depthAttachment.texture = texture
        descriptor.depthAttachment.storeAction = .store
        descriptor.depthAttachment.loadAction = .clear
        return descriptor
    }
    static func postprocess(device: MTLDevice, texture: MTLTexture) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .load
        descriptor.colorAttachments[0].texture = texture
        descriptor.colorAttachments[0].storeAction = .store
        return descriptor
    }
}

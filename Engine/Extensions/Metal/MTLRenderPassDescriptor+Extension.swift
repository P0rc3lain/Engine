//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLRenderPassDescriptor {
    static func lightenScene(device: MTLDevice, depthStencil: MTLTexture, size: CGSize) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].texture = device.makeTextureLightenSceneColor(size: size)
        descriptor.colorAttachments[0].clearColor = MTLClearColor()
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.depthAttachment.texture = depthStencil
        descriptor.depthAttachment.storeAction = .dontCare
        descriptor.depthAttachment.loadAction = .load
        descriptor.stencilAttachment.texture = depthStencil
        descriptor.stencilAttachment.loadAction = .load
        descriptor.stencilAttachment.storeAction = .dontCare
        return descriptor
    }
    static func gBuffer(device: MTLDevice, size: CGSize) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].texture = device.makeTextureGBufferAR(size: size)
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.colorAttachments[0].clearColor = MTLClearColor()
        descriptor.colorAttachments[1].loadAction = .clear
        descriptor.colorAttachments[1].texture = device.makeTextureGBufferNM(size: size)
        descriptor.colorAttachments[1].clearColor = MTLClearColor()
        descriptor.colorAttachments[1].storeAction = .store
        descriptor.colorAttachments[2].loadAction = .clear
        descriptor.colorAttachments[2].texture = device.makeTextureGBufferPR(size: size)
        descriptor.colorAttachments[2].clearColor = MTLClearColor()
        descriptor.colorAttachments[2].storeAction = .store
        let depthStencil = device.makeTextureGBufferDepthStencil(size: size)
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
    static func spotLightShadow(device: MTLDevice, size: CGSize, layers: Int) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        let texture = device.makeTextureSpotLightShadowDepthStencil(size: size, lightsCount: layers)
        descriptor.renderTargetArrayLength = layers
        descriptor.depthAttachment.clearDepth = 1
        descriptor.depthAttachment.texture = texture
        descriptor.depthAttachment.storeAction = .store
        descriptor.depthAttachment.loadAction = .clear
        return descriptor
    }
    static func ssao(device: MTLDevice, size: CGSize) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].texture = device.makeTextureSsao(size: size)
        descriptor.colorAttachments[0].clearColor = MTLClearColor()
        descriptor.colorAttachments[0].storeAction = .store
        return descriptor
    }
    static func bloomSplit(device: MTLDevice, size: CGSize) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].texture = device.makeTextureBloomSplitColor(size: size)
        descriptor.colorAttachments[0].clearColor = MTLClearColor()
        descriptor.colorAttachments[0].storeAction = .store
        return descriptor
    }
    static func bloomMerge(device: MTLDevice, size: CGSize) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].texture = device.makeTextureBloomMergeColor(size: size)
        descriptor.colorAttachments[0].clearColor = MTLClearColor()
        descriptor.colorAttachments[0].storeAction = .store
        return descriptor
    }
    static func postprocess(device: MTLDevice, size: CGSize) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].texture = device.makeTextureBloomMergeColor(size: size)
        descriptor.colorAttachments[0].clearColor = MTLClearColor()
        descriptor.colorAttachments[0].storeAction = .store
        return descriptor
    }
}

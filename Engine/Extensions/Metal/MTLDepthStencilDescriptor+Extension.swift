//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLDepthStencilDescriptor {
    static var gBufferRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.gBufferRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.label = "GBuffer Renderer Depth Stencil"
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
        return descriptor
    }
    static private var lightRenderer: MTLDepthStencilDescriptor {
        // descriptor.label set in objects utilizing the variable
        let stencil = MTLStencilDescriptor.lightRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
        return descriptor
    }
    static var omniRenderer: MTLDepthStencilDescriptor {
        let descriptor = lightRenderer
        descriptor.label = "Omni Light Renderer Depth Stencil"
        return descriptor
    }
    static var ambientRenderer: MTLDepthStencilDescriptor {
        let descriptor = lightRenderer
        descriptor.label = "Ambient Light Renderer Depth Stencil"
        return descriptor
    }
    static var directionalRenderer: MTLDepthStencilDescriptor {
        let descriptor = lightRenderer
        descriptor.label = "Directional Light Renderer Depth Stencil"
        return descriptor
    }
    static var spotRenderer: MTLDepthStencilDescriptor {
        let descriptor = lightRenderer
        descriptor.label = "Spot Light Renderer Depth Stencil"
        return descriptor
    }
    static var spotShadowRenderer: MTLDepthStencilDescriptor {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.label = "Spot Shadow Renderer Depth Stencil"
        descriptor.isDepthWriteEnabled = true
        return descriptor
    }
    static var directionalShadowRenderer: MTLDepthStencilDescriptor {
        let descriptor = spotShadowRenderer
        descriptor.label = "Directional Shadow Renderer Depth Stencil"
        return descriptor
    }
    static var omniShadowRenderer: MTLDepthStencilDescriptor {
        let descriptor = spotShadowRenderer
        descriptor.label = "Omni Shadow Renderer Depth Stencil"
        return descriptor
    }
    static var environmentRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.environmentRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.label = "Environmental Renderer Depth Stencil"
        descriptor.depthCompareFunction = .always
        descriptor.isDepthWriteEnabled = false
        descriptor.frontFaceStencil = stencil
        descriptor.backFaceStencil = stencil
        return descriptor
    }
    static var fogJob: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.fogJob
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.label = "Fog Job Depth Stencil"
        descriptor.depthCompareFunction = .always
        descriptor.isDepthWriteEnabled = false
        descriptor.frontFaceStencil = stencil
        descriptor.backFaceStencil = stencil
        return descriptor
    }
}

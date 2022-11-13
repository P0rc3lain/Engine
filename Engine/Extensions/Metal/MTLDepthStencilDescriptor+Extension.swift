//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLDepthStencilDescriptor {
    func labeled(_ label: String) -> MTLDepthStencilDescriptor {
        self.label = label
        return self
    }
    static var gBuffer: MTLDepthStencilDescriptor {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.label = "GBuffer Depth Stencil"
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = .gBuffer
        return descriptor
    }
    static private var lighten: MTLDepthStencilDescriptor {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .always
        descriptor.isDepthWriteEnabled = false
        descriptor.frontFaceStencil = .lighten
        descriptor.backFaceStencil = .lighten
        return descriptor
    }
    static var omni: MTLDepthStencilDescriptor {
        lighten.labeled("Omni Depth Stencil")
    }
    static var ambient: MTLDepthStencilDescriptor {
        lighten.labeled("Ambient Depth Stencil")
    }
    static var directional: MTLDepthStencilDescriptor {
        lighten.labeled("Directional Depth Stencil")
    }
    static var spot: MTLDepthStencilDescriptor {
        lighten.labeled("Spot Depth Stencil")
    }
    static var spotShadow: MTLDepthStencilDescriptor {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.label = "Spot Shadow Depth Stencil"
        descriptor.isDepthWriteEnabled = true
        return descriptor
    }
    static var directionalShadow: MTLDepthStencilDescriptor {
        spotShadow.labeled("Directional Shadow Depth Stencil")
    }
    static var omniShadow: MTLDepthStencilDescriptor {
        spotShadow.labeled("Omni Shadow Depth Stencil")
    }
    static var environment: MTLDepthStencilDescriptor {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.label = "Environmental Depth Stencil"
        descriptor.depthCompareFunction = .always
        descriptor.isDepthWriteEnabled = false
        descriptor.frontFaceStencil = .environment
        descriptor.backFaceStencil = .environment
        return descriptor
    }
    static var fog: MTLDepthStencilDescriptor {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.label = "Fog Depth Stencil"
        descriptor.depthCompareFunction = .always
        descriptor.isDepthWriteEnabled = false
        descriptor.frontFaceStencil = .fog
        descriptor.backFaceStencil = .fog
        return descriptor
    }
    static var translucent: MTLDepthStencilDescriptor {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.label = "Translucent Depth Stencil"
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = .translucent
        return descriptor
    }
    static var particle: MTLDepthStencilDescriptor {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.label = "Particle Depth Stencil"
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = .particle
        return descriptor
    }
}

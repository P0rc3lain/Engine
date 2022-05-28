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
        let stencil = MTLStencilDescriptor.gBuffer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.label = "GBuffer Depth Stencil"
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
        return descriptor
    }
    static private var lighten: MTLDepthStencilDescriptor {
        // descriptor.label set in objects utilizing the variable
        let stencil = MTLStencilDescriptor.lighten
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
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
        let stencil = MTLStencilDescriptor.environment
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.label = "Environmental Depth Stencil"
        descriptor.depthCompareFunction = .always
        descriptor.isDepthWriteEnabled = false
        descriptor.frontFaceStencil = stencil
        descriptor.backFaceStencil = stencil
        return descriptor
    }
    static var fog: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.fog
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.label = "Fog Depth Stencil"
        descriptor.depthCompareFunction = .always
        descriptor.isDepthWriteEnabled = false
        descriptor.frontFaceStencil = stencil
        descriptor.backFaceStencil = stencil
        return descriptor
    }
}

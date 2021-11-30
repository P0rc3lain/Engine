//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLDepthStencilDescriptor {
    static var gBufferRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.gBufferRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
        return descriptor
    }
    static var lightRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.lightRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
        return descriptor
    }
    static var omniRenderer: MTLDepthStencilDescriptor {
        lightRenderer
    }
    static var spotRenderer: MTLDepthStencilDescriptor {
        lightRenderer
    }
    static var spotShadowRenderer: MTLDepthStencilDescriptor {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        return descriptor
    }
    static var directionalShadowRenderer: MTLDepthStencilDescriptor {
        spotShadowRenderer
    }
    static var omniShadowRenderer: MTLDepthStencilDescriptor {
        spotShadowRenderer
    }
    static var ambientRenderer: MTLDepthStencilDescriptor {
        lightRenderer
    }
    static var directionalRenderer: MTLDepthStencilDescriptor {
        lightRenderer
    }
    static var environmentRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.environmentRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .always
        descriptor.isDepthWriteEnabled = false
        descriptor.frontFaceStencil = stencil
        descriptor.backFaceStencil = stencil
        return descriptor
    }
    static var fogJob: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.fogJob
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .always
        descriptor.isDepthWriteEnabled = false
        descriptor.frontFaceStencil = stencil
        descriptor.backFaceStencil = stencil
        return descriptor
    }
}

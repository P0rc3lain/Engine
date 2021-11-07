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
    static var omniRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.omniRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
        return descriptor
    }
    static var spotRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.spotRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
        return descriptor
    }
    static var ambientRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.ambientRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
        return descriptor
    }
    static var directionalRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.directionalRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
        return descriptor
    }
    static var environmentRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.environmentRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .always
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
        descriptor.backFaceStencil = stencil
        return descriptor
    }
}

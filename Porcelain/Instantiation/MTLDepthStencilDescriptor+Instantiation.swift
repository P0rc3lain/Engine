//
//  MTLDepthStencilDescriptor+Instantiation.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 13/11/2020.
//

import Metal

extension MTLDepthStencilDescriptor {
    static var forwardRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.forwardRenderer
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.isDepthWriteEnabled = true
        descriptor.frontFaceStencil = stencil
        return descriptor
    }
    static var lightPassRenderer: MTLDepthStencilDescriptor {
        let stencil = MTLStencilDescriptor.lightPassRenderer
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

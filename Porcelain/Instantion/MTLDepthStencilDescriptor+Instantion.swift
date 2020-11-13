//
//  MTLDepthStencilDescriptor.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 13/11/2020.
//

import Metal

extension MTLDepthStencilDescriptor {
    static var forwardRenderer: MTLDepthStencilDescriptor {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .lessEqual
        depthStencilDescriptor.isDepthWriteEnabled = true
        return depthStencilDescriptor
    }
}

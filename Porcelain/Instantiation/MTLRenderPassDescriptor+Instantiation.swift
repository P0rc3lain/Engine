//
//  MTLRenderPassDescriptor+Instantiation.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Metal

extension MTLRenderPassDescriptor {
    static func lightenScene(device: MTLDevice, size: CGSize) -> MTLRenderPassDescriptor {
        let colorTexture = device.makeTextureLightenSceneColor(size: size)
        let depthTexture = device.makeTextureLightenSceneDepth(size: size)
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].texture = colorTexture
        descriptor.colorAttachments[0].clearColor = MTLClearColor.init()
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.depthAttachment.clearDepth = 1
        descriptor.depthAttachment.texture = depthTexture
        descriptor.depthAttachment.storeAction = .store
        return descriptor
    }
}

//
//  MTLVertexDescriptor.swift
//  Engine
//
//  Created by Mateusz Stompór on 11/10/2021.
//

import MetalKit

extension MTLVertexDescriptor {
    // MARK: - Public
    public static var porcelain: MTLVertexDescriptor {
        MTKMetalVertexDescriptorFromModelIO(MDLVertexDescriptor.porcelain)!
    }
    static var environmentRenderer: MTLVertexDescriptor {
        let descriptor = MTLVertexDescriptor()
        descriptor.layouts[0] = MTLVertexBufferLayoutDescriptor.environmentRenderer
        descriptor.attributes[0].format = .float4
        descriptor.attributes[0].offset = 0
        descriptor.attributes[0].bufferIndex = 0
        return descriptor
    }
}

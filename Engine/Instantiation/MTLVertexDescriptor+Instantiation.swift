//
//  MTLVertexDescriptor+Instantiation.swift
//  Engine
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import Metal

extension MTLVertexDescriptor {
    static var environmentRenderer: MTLVertexDescriptor {
        let descriptor = MTLVertexDescriptor()
        descriptor.layouts[0] = MTLVertexBufferLayoutDescriptor.environmentRenderer
        descriptor.attributes[0].format = .float4
        descriptor.attributes[0].offset = 0
        descriptor.attributes[0].bufferIndex = 0
        return descriptor
    }
}

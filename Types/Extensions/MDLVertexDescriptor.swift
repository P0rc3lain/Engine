//
//  MDLVertexDescriptor.swift
//  Types
//
//  Created by Mateusz Stompór on 11/10/2021.
//

import ModelIO
import MetalBinding

extension MDLVertexDescriptor {
    // MARK: - Properties
    public static var porcelain: MDLVertexDescriptor {
        let descriptor = MDLVertexDescriptor()
        descriptor.layouts = [MDLVertexBufferLayout(stride: MemoryLayout<Vertex>.size)]
        descriptor.attributes = [
            MDLVertexAttribute(name: MDLVertexAttributePosition,
                               format: .float3,
                               offset: MemoryLayout<Vertex>.offset(of: \Vertex.position)!,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeNormal,
                               format: .float3,
                               offset: MemoryLayout<Vertex>.offset(of: \Vertex.normal)!,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeTangent,
                               format: .float3,
                               offset: MemoryLayout<Vertex>.offset(of: \Vertex.tangent)!,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate,
                               format: .float2,
                               offset: MemoryLayout<Vertex>.offset(of: \Vertex.textureUV)!,
                               bufferIndex: 0)
        ]
        return descriptor
    }
}

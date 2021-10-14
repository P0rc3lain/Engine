//
//  MDLVertexDescriptor.swift
//  Engine
//
//  Created by Mateusz Stompór on 11/11/2020.
//

import ModelIO
import ShaderTypes

extension MDLVertexDescriptor {
    static var porcelainMeshVertexDescriptor: MDLVertexDescriptor {
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

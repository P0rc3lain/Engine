//
//  MDLVertexDescriptor.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 11/11/2020.
//

import ModelIO
import ShaderTypes

extension MDLVertexDescriptor {
    static var porcelainMeshVertexDescriptor: MDLVertexDescriptor {
        let descriptor = MDLVertexDescriptor()
        descriptor.layouts = [MDLVertexBufferLayout(stride: MemoryLayout<VertexP3N3T3Tx2>.size)]
        descriptor.attributes = [
            MDLVertexAttribute(name: MDLVertexAttributePosition,
                               format: .float3,
                               offset: MemoryLayout<VertexP3N3T3Tx2>.offset(of: \VertexP3N3T3Tx2.position)!,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeNormal,
                               format: .float3,
                               offset: MemoryLayout<VertexP3N3T3Tx2>.offset(of: \VertexP3N3T3Tx2.normal)!,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeTangent,
                               format: .float3,
                               offset: MemoryLayout<VertexP3N3T3Tx2>.offset(of: \VertexP3N3T3Tx2.tangent)!,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate,
                               format: .float2,
                               offset: MemoryLayout<VertexP3N3T3Tx2>.offset(of: \VertexP3N3T3Tx2.textureUV)!,
                               bufferIndex: 0)
        ]
        return descriptor
    }
}

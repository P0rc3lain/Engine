//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import ModelIO

extension MDLVertexDescriptor {
    // MARK: - Properties
    public static var porcelain: MDLVertexDescriptor? {
        guard let positionOffset = MemoryLayout<Vertex>.offset(of: \Vertex.position),
              let normalOffset = MemoryLayout<Vertex>.offset(of: \Vertex.normal),
              let tangentOffset = MemoryLayout<Vertex>.offset(of: \Vertex.tangent),
              let textureUVOffset = MemoryLayout<Vertex>.offset(of: \Vertex.textureUV),
              let jointIndices = MemoryLayout<Vertex>.offset(of: \Vertex.jointIndices),
              let jointWeights = MemoryLayout<Vertex>.offset(of: \Vertex.jointWeights) else {
            return nil
        }
        let descriptor = MDLVertexDescriptor()
        descriptor.layouts = [MDLVertexBufferLayout(stride: MemoryLayout<Vertex>.size)]
        descriptor.attributes = [
            MDLVertexAttribute(name: MDLVertexAttributePosition,
                               format: .float3,
                               offset: positionOffset,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeNormal,
                               format: .float3,
                               offset: normalOffset,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeTangent,
                               format: .float3,
                               offset: tangentOffset,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeTextureCoordinate,
                               format: .float2,
                               offset: textureUVOffset,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeJointIndices,
                               format: .uShort4,
                               offset: jointIndices,
                               bufferIndex: 0),
            MDLVertexAttribute(name: MDLVertexAttributeJointWeights,
                               format: .float4,
                               offset: jointWeights,
                               bufferIndex: 0)
        ]
        return descriptor
    }
}

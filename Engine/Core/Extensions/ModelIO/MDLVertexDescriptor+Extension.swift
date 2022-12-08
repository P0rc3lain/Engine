//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared
import ModelIO

extension MDLVertexDescriptor {
    public static var porcelain: MDLVertexDescriptor? {
        assert(MAX_JOINT_NUMBER == 4, "Vertex Descriptor is setup to use up to four joints")
        guard let positionOffset = MemoryLayout.offset(of: \Vertex.position),
              let normalOffset = MemoryLayout.offset(of: \Vertex.normal),
              let tangentOffset = MemoryLayout.offset(of: \Vertex.tangent),
              let textureUVOffset = MemoryLayout.offset(of: \Vertex.textureUV),
              let jointIndices = MemoryLayout.offset(of: \Vertex.jointIndices),
              let jointWeights = MemoryLayout.offset(of: \Vertex.jointWeights) else {
            assertionFailure("Could not retrieve offsets")
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

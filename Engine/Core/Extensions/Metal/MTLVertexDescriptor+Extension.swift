//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared
import MetalKit
import ModelIO

extension MTLVertexDescriptor {
    public static var vertex: MTLVertexDescriptor? {
        guard let mdlVertexDescriptor = MDLVertexDescriptor.porcelain else {
            assertionFailure("Cannot convert vertex descriptor")
            return nil
        }
        return MTKMetalVertexDescriptorFromModelIO(mdlVertexDescriptor)
    }
    static var vertexP: MTLVertexDescriptor? {
        guard let positionOffset = MemoryLayout.offset(of: \VertexP.position) else {
            assertionFailure("Could not retrieve offset")
            return nil
        }
        let descriptor = MTLVertexDescriptor()
        descriptor.layouts[0] = .vertexP
        descriptor.attributes[0].format = .float3
        descriptor.attributes[0].offset = positionOffset
        descriptor.attributes[0].bufferIndex = 0
        return descriptor
    }
    static var particle: MTLVertexDescriptor? {
        guard let positionOffset = MemoryLayout.offset(of: \FrozenParticle.position),
              let lifeOffset = MemoryLayout.offset(of: \FrozenParticle.life),
              let lifespanOffset = MemoryLayout.offset(of: \FrozenParticle.lifespan),
              let scaleOffset = MemoryLayout.offset(of: \FrozenParticle.scale) else {
            assertionFailure("Could not retrieve offsets")
            return nil
        }
        let descriptor = MTLVertexDescriptor()
        descriptor.layouts[0] = .particle
        descriptor.attributes[0].format = .float3
        descriptor.attributes[0].offset = positionOffset
        descriptor.attributes[0].bufferIndex = 0
        descriptor.attributes[1].format = .float
        descriptor.attributes[1].offset = lifeOffset
        descriptor.attributes[1].bufferIndex = 0
        descriptor.attributes[2].format = .float
        descriptor.attributes[2].offset = lifespanOffset
        descriptor.attributes[2].bufferIndex = 0
        descriptor.attributes[3].format = .float
        descriptor.attributes[3].offset = scaleOffset
        descriptor.attributes[3].bufferIndex = 0
        return descriptor
    }
}

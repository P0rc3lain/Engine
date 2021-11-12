//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalKit
import MetalBinding

extension MTLVertexDescriptor {
    public static var vertex: MTLVertexDescriptor? {
        guard let mdlVertexDescriptor = MDLVertexDescriptor.porcelain else {
            return nil
        }
        return MTKMetalVertexDescriptorFromModelIO(mdlVertexDescriptor)
    }
    static var vertexP: MTLVertexDescriptor? {
        guard let positionOffset = MemoryLayout<VertexP>.offset(of: \VertexP.position) else {
            return nil
        }
        let descriptor = MTLVertexDescriptor()
        descriptor.layouts[0] = .vertexP
        descriptor.attributes[0].format = .float3
        descriptor.attributes[0].offset = positionOffset
        descriptor.attributes[0].bufferIndex = 0
        return descriptor
    }
}

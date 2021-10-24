//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
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

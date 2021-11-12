//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

extension MTLVertexBufferLayoutDescriptor {
    static var vertexP: MTLVertexBufferLayoutDescriptor {
        let layout = MTLVertexBufferLayoutDescriptor()
        layout.stepFunction = .perVertex
        layout.stride = MemoryLayout<VertexP>.stride
        layout.stepRate = 1
        return layout
    }
}

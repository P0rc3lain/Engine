//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLVertexBufferLayoutDescriptor {
    static var environmentRenderer: MTLVertexBufferLayoutDescriptor {
        let layout = MTLVertexBufferLayoutDescriptor()
        layout.stepFunction = .perVertex
        layout.stride = MemoryLayout<SIMD3<Float>>.stride
        layout.stepRate = 1
        return layout
    }
}

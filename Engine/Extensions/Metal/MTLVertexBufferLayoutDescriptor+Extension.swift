//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

extension MTLVertexBufferLayoutDescriptor {
    convenience init(stride: Int,
                     stepFunction: MTLVertexStepFunction,
                     stepRate: Int) {
        self.init()
        self.stride = stride
        self.stepFunction = stepFunction
        self.stepRate = stepRate
    }
    static var vertexP: MTLVertexBufferLayoutDescriptor {
        MTLVertexBufferLayoutDescriptor(stride: MemoryLayout<VertexP>.stride,
                                        stepFunction: .perVertex,
                                        stepRate: 1)
    }
    static var vertexPUV: MTLVertexBufferLayoutDescriptor {
        MTLVertexBufferLayoutDescriptor(stride: MemoryLayout<VertexPUV>.stride,
                                        stepFunction: .perVertex,
                                        stepRate: 1)
    }
}

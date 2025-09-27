//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLCommandBufferDescriptor {
    static var noLogButRetain: MTLCommandBufferDescriptor {
        let descriptor = MTLCommandBufferDescriptor()
        descriptor.logState = .none
        descriptor.retainedReferences = true
        descriptor.errorOptions = []
        return descriptor
    }
}

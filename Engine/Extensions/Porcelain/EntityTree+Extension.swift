//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension EntityTree {
    var modelUniforms: [ModelUniforms] {
        if isEmpty {
            return []
        }
        var uniforms = [ModelUniforms]()
        uniforms.reserveCapacity(self.count)
        for index in self.indices {
            let parentIdx = self[index].parentIdx
            let finalTransform = self[index].data.transform.transformation(at: Date().timeIntervalSince1970)
            let transform = parentIdx != .nil ? uniforms[parentIdx].modelMatrix * finalTransform : finalTransform
            uniforms.append(ModelUniforms(modelMatrix: transform,
                                          modelMatrixInverse: transform.inverse))
        }
        return uniforms
    }
}

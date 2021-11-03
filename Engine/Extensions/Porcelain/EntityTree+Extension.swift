//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension EntityTree {
    var modelUniforms: [ModelUniforms] {
        if objects.isEmpty {
            return []
        }
        var uniforms = [ModelUniforms]()
        uniforms.reserveCapacity(objects.count)
        for index in objects.indices {
            let parentIdx = objects[index].parentIdx
            let finalTransform = objects[index].data.transform.transformation(at: Date().timeIntervalSince1970)
            let transform = parentIdx != .nil ? uniforms[parentIdx].modelMatrix * finalTransform : finalTransform
            uniforms.append(ModelUniforms(modelMatrix: transform,
                                          modelMatrixInverse: transform.inverse))
        }
        return uniforms
    }
}

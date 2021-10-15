//
//  EntityTree+Extension.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import MetalBinding

extension EntityTree {
    var modelUniforms: [ModelUniforms] {
        if objects.count == 0 {
            return []
        }
        var uniforms = [ModelUniforms]()
        uniforms.reserveCapacity(objects.count)
        for i in 0 ..< objects.count {
            let parentIdx = objects[i].parentIdx
            let finalTransform = objects[i].data.transform.finalTransfrom
            let transform = parentIdx != .nil ? uniforms[parentIdx].modelMatrix * finalTransform : finalTransform
            let transformInverse = transform.inverse
            uniforms.append(ModelUniforms(modelMatrix: transform, modelMatrixInverse: transformInverse,
                                          modelMatrixInverse2: transform, modelMatrixInverse3: transform))
        }
        return uniforms
    }
}

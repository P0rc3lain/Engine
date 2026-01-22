//
//  Copyright © 2026 Mateusz Stompór. All rights reserved.
//

import simd

class PNNodeUpdater {
    private let interactor = PNIBoundingBoxInteractor.default
    init() {
        // Empty
    }
    func update(rootNode: PNScenePiece) {
        let sceneUpdateInterval = psignposter.beginInterval("Scene update")
        update(from: rootNode, worldTransform: .identity)
        psignposter.endInterval("Scene update", sceneUpdateInterval)
    }
    private func update(from node: PNScenePiece, worldTransform: simd_float4x4) {
        let concatenatedTransform = worldTransform * node.data.transform

        node.data.worldTransform = concatenatedTransform
        node.data.modelUniforms = PNWModelUniforms(modelMatrix: concatenatedTransform,
                                                   modelMatrixInverse: concatenatedTransform.inverse)

        if node.children.isEmpty {
            if let bb = node.data.intrinsicBoundingBox {
                let aabb = interactor.aabb(interactor.multiply(node.data.transform, bb))
                node.data.localBoundingBox = aabb
            } else {
                node.data.localBoundingBox = nil
            }
            node.data.childrenMergedBoundingBox = nil
        } else {
            for child in node.children {
                update(from: child, worldTransform: concatenatedTransform)
            }
            let localBoundingBoxes = node.children.compactMap { $0.data.localBoundingBox }
            let mergedLocalBoundingBoxes = localBoundingBoxes.reduce(interactor.merge(_:_:))
            node.data.childrenMergedBoundingBox = mergedLocalBoundingBoxes

            if let bb = node.data.intrinsicBoundingBox {
                if let childrenBB = mergedLocalBoundingBoxes {
                    let merged = interactor.merge(bb, childrenBB)
                    let aabb = interactor.aabb(interactor.multiply(node.data.transform, merged))
                    node.data.localBoundingBox = aabb
                } else {
                    let aabb = interactor.aabb(interactor.multiply(node.data.transform, bb))
                    node.data.localBoundingBox = aabb
                }
            } else {
                if let childrenBB = mergedLocalBoundingBoxes {
                    let aabb = interactor.aabb(interactor.multiply(node.data.transform, childrenBB))
                    node.data.localBoundingBox = aabb
                } else {
                    node.data.localBoundingBox = nil
                }
            }
        }
        if let localBoundingBox = node.data.localBoundingBox {
            let aabb = interactor.aabb(interactor.multiply(worldTransform, localBoundingBox))
            node.data.worldBoundingBox = aabb
        } else {
            node.data.worldBoundingBox = nil
        }
    }
}

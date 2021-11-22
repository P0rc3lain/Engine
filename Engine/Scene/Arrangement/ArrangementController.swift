//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

struct ArrangementController {
    static func arrangement<DataType, IndexType, GeometryType, TextureType>(scene: inout SceneDescription<DataType, IndexType, GeometryType, TextureType>) -> PNArrangement {
        var uniforms = modelUniforms(tree: &scene.entities)
        return PNArrangement(positions: uniforms, boundingBoxes: boundingBoxes(scene: &scene, uniforms: &uniforms))
    }
    private static func boundingBoxes<DataType, IndexType, GeometryType, TextureType>(scene: inout SceneDescription<DataType, IndexType, GeometryType, TextureType>,
                                                                                      uniforms: inout [ModelUniforms]) -> [PNBoundingBox] {
        var boundingBoxes = [PNBoundingBox](minimalCapacity: scene.entities.count)
        let interactor = PNIBoundingBoxInteractor.default
        for i in scene.entities.indices {
            let index = scene.entities.count - (1 + i)
            let transform = uniforms[index].modelMatrix
            switch scene.entities[index].data.type {
            case .mesh:
                let boundingBox = interactor.aabb(interactor.multiply(transform, scene.meshes[scene.entities[index].data.referenceIdx].boundingBox))
                boundingBoxes.insert(boundingBox)
            case .spotLight:
                let boundingBox = interactor.aabb(interactor.multiply(transform, scene.spotLights[scene.entities[index].data.referenceIdx].boundingBox))
                boundingBoxes.insert(boundingBox)
            case .omniLight:
                let boundingBox = interactor.aabb(interactor.multiply(transform, scene.omniLights[scene.entities[index].data.referenceIdx].boundingBox))
                boundingBoxes.insert(boundingBox)
            case .ambientLight:
                let boundingBox = interactor.aabb(interactor.multiply(transform, scene.ambientLights[scene.entities[index].data.referenceIdx].boundingBox))
                boundingBoxes.insert(boundingBox)
            case .group:
                let children = scene.entities.children(of: index)
                if !children.isEmpty {
                    let firstChild = children.first!
                    let offset = -scene.entities.count + i
                    var mergedBox = boundingBoxes[firstChild + offset]
                    for childIndex in children.dropFirst() {
                        mergedBox = interactor.merge(mergedBox, boundingBoxes[childIndex + offset])
                    }
                    boundingBoxes.insert(mergedBox)
                } else {
                    let boundingBox = interactor.aabb(interactor.multiply(transform, interactor.from(bound: PNBound(min: .zero, max: .zero))))
                    boundingBoxes.insert(boundingBox)
                }

            case .camera:
                let boundingBox = interactor.aabb(interactor.multiply(transform, scene.cameras[scene.entities[index].data.referenceIdx].boundingBox))
                boundingBoxes.insert(boundingBox)
            }
        }
        return boundingBoxes
    }
    private static func modelUniforms(tree: inout EntityTree) -> [ModelUniforms] {
        if tree.isEmpty {
            return []
        }
        var uniforms = [ModelUniforms](minimalCapacity: tree.count)
        for index in tree.indices {
            let parentIdx = tree[index].parentIdx
            let finalTransform = tree[index].data.transform.transformation(at: Date().timeIntervalSince1970, interpolator: PNIInterpolator())
            let transform = parentIdx != .nil ? uniforms[parentIdx].modelMatrix * finalTransform : finalTransform
            uniforms.append(ModelUniforms(modelMatrix: transform,
                                          modelMatrixInverse: transform.inverse))
        }
        return uniforms
    }
}

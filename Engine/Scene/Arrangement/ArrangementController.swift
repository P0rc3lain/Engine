//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

struct ArrangementController {
    static func arrangement<DataType, IndexType, GeometryType, TextureType>(scene: inout SceneDescription<DataType, IndexType, GeometryType, TextureType>) -> Arrangement {
        var uniforms = modelUniforms(tree: &scene.entities)
        return Arrangement(worldPositions: uniforms, worldBoundingBoxes: boundingBoxes(scene: &scene, uniforms: &uniforms))
    }
    private static func boundingBoxes<DataType, IndexType, GeometryType, TextureType>(scene: inout SceneDescription<DataType, IndexType, GeometryType, TextureType>,
                                                                                      uniforms: inout [ModelUniforms]) -> [BoundingBox] {
        var boundingBoxes = [BoundingBox](minimalCapacity: scene.entities.count)
        for i in scene.entities.indices {
            let index = scene.entities.count - (1 + i)
            let transform = uniforms[index].modelMatrix
            switch scene.entities[index].data.type {
            case .mesh:
                boundingBoxes.insert((transform * scene.meshBoundingBoxes[scene.entities[index].data.referenceIdx]).aabb)
            case .omniLight, .spotLight:
                boundingBoxes.insert((transform * BoundingBox.from(bound: Bound(min: [-100, -100, -100],
                                                                                max: [100, 100, 100]))).aabb)
            case .ambientLight:
                boundingBoxes.insert((transform * scene.ambientLights[scene.entities[index].data.referenceIdx].boundingBox).aabb)
            case .group:
                let children = scene.entities.children(of: index)
                if !children.isEmpty {
                    let firstChild = children.first!
                    let offset = -scene.entities.count + i
                    var mergedBox = boundingBoxes[firstChild + offset]
                    for childIndex in children.dropFirst() {
                        mergedBox = mergedBox.merge(boundingBoxes[childIndex + offset])
                    }
                    boundingBoxes.insert(mergedBox)
                } else {
                    boundingBoxes.insert((transform * BoundingBox.from(bound: .zero)).aabb)
                }
                
            case .camera:
                boundingBoxes.insert((transform * scene.cameras[scene.entities[index].data.referenceIdx].boundingBox).aabb)
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
            let finalTransform = tree[index].data.transform.transformation(at: Date().timeIntervalSince1970)
            let transform = parentIdx != .nil ? uniforms[parentIdx].modelMatrix * finalTransform : finalTransform
            uniforms.append(ModelUniforms(modelMatrix: transform,
                                          modelMatrixInverse: transform.inverse))
        }
        return uniforms
    }
}

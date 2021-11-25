//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

struct PNITranscriber: PNTranscriber {
    private let transformCalculator: PNTransformCalculator
    init(transformCalculator: PNTransformCalculator) {
        self.transformCalculator = transformCalculator
    }
    func transcribe(scene: PNScene) -> PNSceneDescription {
        var sceneDescription = PNSceneDescription()
        write(node: scene.rootNode, scene: &sceneDescription, parentIndex: .nil)
        sceneDescription.boundingBoxes = boundingBoxes(scene: &sceneDescription)
        return sceneDescription
    }
    private func write(node: PNNode<PNSceneNode>, scene: inout PNSceneDescription, parentIndex: PNIndex) {
        let index = node.data.write(scene: &scene, parentIdx: parentIndex)
        let transform = transformCalculator.transformation(node: node.data,
                                                           parent: parentIndex,
                                                           scene: &scene)
        scene.uniforms.append(ModelUniforms.from(transform: transform))
        for child in node.children {
            write(node: child, scene: &scene, parentIndex: index)
            let childTransform = transformCalculator.transformation(node: node.data,
                                                                    parent: parentIndex,
                                                                    scene: &scene)
            scene.uniforms.append(ModelUniforms.from(transform: childTransform))
        }
    }
    private func boundingBoxes(scene: inout PNSceneDescription) -> [PNBoundingBox] {
        var boundingBoxes = [PNBoundingBox](minimalCapacity: scene.entities.count)
        let interactor = PNIBoundingBoxInteractor.default
        for i in scene.entities.indices {
            let index = scene.entities.count - (1 + i)
            let transform = scene.uniforms[index].modelMatrix
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
}

//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

struct PNIBoundingBoxGenerator: PNBoundingBoxGenerator {
    private let interactor: PNBoundingBoxInteractor
    init(interactor: PNBoundingBoxInteractor) {
        self.interactor = interactor
    }
    func boundingBoxes(scene: PNSceneDescription) -> [PNBoundingBox] {
        var boundingBoxes = [PNBoundingBox](minimalCapacity: scene.entities.count)
        for i in scene.entities.indices {
            let index = scene.entities.count - (1 + i)
            let transform = scene.uniforms[index].modelMatrix
            switch scene.entities[index].data.type {
            case .animatedMesh:
                let modelIdx = scene.entities[index].data.referenceIdx
                let meshIdx = scene.animatedModels[modelIdx].mesh
                let boundingBox = interactor.aabb(interactor.multiply(transform, scene.meshes[meshIdx].boundingBox))
                boundingBoxes.insert(boundingBox)
            case .mesh:
                let modelIdx = scene.entities[index].data.referenceIdx
                let meshIdx = scene.models[modelIdx].mesh
                let boundingBox = interactor.aabb(interactor.multiply(transform, scene.meshes[meshIdx].boundingBox))
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
                if let firstChild = children.first {
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
                let boundingBox = interactor.aabb(interactor.multiply(transform.inverse, scene.cameras[scene.entities[index].data.referenceIdx].boundingBox))
                boundingBoxes.insert(boundingBox)
            case .particle:
                let particleSystemIndex = scene.entities[index].data.referenceIdx
                let rules = scene.particles[particleSystemIndex].positioningRules
                let boundingBox = interactor.aabb(interactor.multiply(transform,
                                                                      interactor.from(bound: rules.bound)))

                boundingBoxes.insert(boundingBox)
            }
        }
        return boundingBoxes
    }
}

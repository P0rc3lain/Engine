//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

struct PNIBoundingBoxGenerator: PNBoundingBoxGenerator {
    private let interactor: PNBoundingBoxInteractor
    init(interactor: PNBoundingBoxInteractor) {
        self.interactor = interactor
    }
    func boundingBoxes(scene: PNSceneDescription) -> [PNBoundingBox] {
        var boundingBoxes = [PNBoundingBox](repeating: .zero, count: scene.entities.count)
        for i in scene.entities.indices.reversed() {
            let transform = scene.uniforms[i].modelMatrix
            switch scene.entities[i].data.type {
            case .animatedMesh:
                let modelIdx = scene.entities[i].data.referenceIdx
                let meshIdx = scene.animatedModels[modelIdx].mesh
                boundingBoxes[i] = interactor.aabb(interactor.multiply(transform, scene.meshes[meshIdx].boundingBox))
            case .mesh:
                let modelIdx = scene.entities[i].data.referenceIdx
                let meshIdx = scene.models[modelIdx].mesh
                boundingBoxes[i] = interactor.aabb(interactor.multiply(transform, scene.meshes[meshIdx].boundingBox))
            case .spotLight:
                boundingBoxes[i] = interactor.aabb(interactor.multiply(transform, scene.spotLights[scene.entities[i].data.referenceIdx].boundingBox))
            case .omniLight:
                boundingBoxes[i] = interactor.aabb(interactor.multiply(transform, scene.omniLights[scene.entities[i].data.referenceIdx].boundingBox))
            case .ambientLight:
                boundingBoxes[i] = interactor.aabb(interactor.multiply(transform, scene.ambientLights[scene.entities[i].data.referenceIdx].boundingBox))
            case .group:
                // implicit size
                break
            case .camera:
                boundingBoxes[i] = interactor.aabb(interactor.multiply(transform.inverse, scene.cameras[scene.entities[i].data.referenceIdx].boundingBox))
            case .particle:
                let particleSystemIndex = scene.entities[i].data.referenceIdx
                let rules = scene.particles[particleSystemIndex].positioningRules
                boundingBoxes[i] = interactor.aabb(interactor.multiply(transform,
                                                                       interactor.from(bound: rules.bound)))
            }
            if let mergedBox = scene.entities.children(of: i).map({ boundingBoxes[$0] }).reduce(interactor.merge) {
                boundingBoxes[i] = interactor.merge(mergedBox, boundingBoxes[i])
            }
        }
        return boundingBoxes
    }
}

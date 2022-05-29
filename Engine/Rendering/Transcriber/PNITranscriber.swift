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
        let sceneDescription = PNSceneDescription()
        write(node: scene.rootNode, scene: sceneDescription, parentIndex: .nil)
        sceneDescription.boundingBoxes = boundingBoxes(scene: sceneDescription)
        write(lights: scene.directionalLights, scene: sceneDescription)
        updatePalettes(scene: sceneDescription)
        sceneDescription.skyMap = scene.environmentMap
        return sceneDescription
    }
    private func write(lights: [PNDirectionalLight], scene: PNSceneDescription) {
        let cameraBB = scene.boundingBoxes[scene.activeCameraIdx]
        for light in lights {
            let interactor = PNIBoundingBoxInteractor.default
            let orientation = simd.simd_float4x4.from(directionVector: light.direction)
            let orientationInverse = orientation.inverse
            let bound = interactor.bound(interactor.aabb(interactor.multiply(orientationInverse, cameraBB)))
            let projectionMatrix = simd_float4x4.orthographicProjection(left: bound.min.x,
                                                                        right: bound.max.x,
                                                                        top: bound.max.y,
                                                                        bottom: bound.min.y,
                                                                        near: bound.min.z,
                                                                        far: bound.max.z)
            scene.directionalLights.append(DirectionalLight(color: light.color,
                                                            intensity: light.intensity,
                                                            rotationMatrix: orientation,
                                                            rotationMatrixInverse: orientationInverse,
                                                            projectionMatrix: projectionMatrix,
                                                            projectionMatrixInverse: projectionMatrix.inverse))
        }
    }
    private func write(node: PNNode<PNSceneNode>, scene: PNSceneDescription, parentIndex: PNIndex) {
        let index = node.data.write(scene: scene, parentIdx: parentIndex)
        let transform = transformCalculator.transformation(node: node.data,
                                                           parent: parentIndex,
                                                           scene: scene)
        scene.uniforms.append(ModelUniforms.from(transform: transform))
        for child in node.children {
            write(node: child, scene: scene, parentIndex: index)
        }
    }
    private func boundingBoxes(scene: PNSceneDescription) -> [PNBoundingBox] {
        var boundingBoxes = [PNBoundingBox](minimalCapacity: scene.entities.count)
        let interactor = PNIBoundingBoxInteractor.default
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
            }
        }
        return boundingBoxes
    }
    private func updatePalettes(scene: PNSceneDescription) {
        for index in scene.animatedModels.indices {
            let palette = generatePalette(objectIdx: index, scene: scene)
            scene.paletteOffset.append(scene.palettes.count)
            scene.palettes.append(contentsOf: palette)
        }
    }
    private func generatePalette(objectIdx: Int, scene: PNSceneDescription) -> [simd_float4x4] {
        let skeletonIdx = scene.animatedModels[objectIdx].skeleton
        let skeleton = scene.skeletons[skeletonIdx]
        let date = Date().timeIntervalSince1970
        guard let animation = skeleton.animations.first else {
            return []
        }
        let transformations = animation.localTransformation(at: date, interpolator: PNIInterpolator())
        return skeleton.calculatePose(animationPose: transformations)
    }
    static var `default`: PNITranscriber {
        let interpolator = PNIInterpolator()
        let transformCalculator = PNITransformCalculator(interpolator: interpolator)
        return PNITranscriber(transformCalculator: transformCalculator)
    }
}

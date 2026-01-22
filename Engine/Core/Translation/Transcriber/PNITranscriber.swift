//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared

struct PNITranscriber: PNTranscriber {
    private let interactor: PNBoundingBoxInteractor
    private let paletteGenerator: PNPaletteGenerator
    init(boundingBoxInteractor: PNBoundingBoxInteractor,
         paletteGenerator: PNPaletteGenerator) {
        self.interactor = boundingBoxInteractor
        self.paletteGenerator = paletteGenerator
    }
    func transcribe(scene: PNScene) -> PNSceneDescription {
        let sceneDescription = PNSceneDescription()
        write(node: scene.rootNode, scene: sceneDescription, parentIndex: .nil)
        write(lights: scene.directionalLights, scene: sceneDescription)
        let palettes = paletteGenerator.palettes(scene: sceneDescription)
        sceneDescription.palettes = palettes.palettes
        sceneDescription.paletteOffset = palettes.offsets
        sceneDescription.skyMap = scene.environmentMap
        assert(validate(scene: sceneDescription), "Scene improperly formed")
        return sceneDescription
    }
    private func write(lights: [PNDirectionalLight], scene: PNSceneDescription) {
        // Getting bounding box of root node
        guard let sceneBB = scene.boundingBoxes[0] else {
            return
        }
        for light in lights {
            let orientation = simd_float4x4.from(directionVector: light.direction)
            let orientationInverse = orientation.inverse
            let bound = interactor.bound(interactor.aabb(interactor.multiply(orientationInverse, sceneBB)))
            let projectionMatrix = simd_float4x4.orthographicProjection(bound: bound)
            scene.directionalLights.append(DirectionalLight(color: light.color,
                                                            intensity: light.intensity,
                                                            rotationMatrix: orientation,
                                                            rotationMatrixInverse: orientationInverse,
                                                            projectionMatrix: projectionMatrix,
                                                            projectionMatrixInverse: projectionMatrix.inverse,
                                                            castsShadows: light.castsShadows ? 1 : 0))
        }
    }
    private func write(node: PNScenePiece, scene: PNSceneDescription, parentIndex: PNIndex) {
        node.data.update()
        let index = node.data.write(scene: scene, parentIdx: parentIndex)
        scene.uniforms.append(node.data.modelUniforms)
        scene.boundingBoxes.append(node.data.worldBoundingBox)
        node.children.forEach {
            write(node: $0, scene: scene, parentIndex: index)
        }
    }
    static var `default`: PNITranscriber {
        let boundingBoxInteractor = PNIBoundingBoxInteractor.default
        return PNITranscriber(boundingBoxInteractor: boundingBoxInteractor,
                              paletteGenerator: PNIPaletteGenerator())
    }
}

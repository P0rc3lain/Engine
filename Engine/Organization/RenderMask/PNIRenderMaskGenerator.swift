//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIRenderMaskGenerator: PNRenderMaskGenerator {
    private let cullingController: PNCullingController
    private let interactor: PNBoundingBoxInteractor
    init(cullingController: PNCullingController,
         interactor: PNBoundingBoxInteractor) {
        self.cullingController = cullingController
        self.interactor = interactor
    }
    public func generate(scene: PNSceneDescription) -> PNRenderMask {
        PNRenderMask(cameras: generateCameraRenderMask(scene: scene),
                     spotLights: generateSpotRenderMasks(scene: scene),
                     omniLights: generateRenderMasks(scene: scene))
    }
    private func generateSpotRenderMasks(scene: PNSceneDescription) -> [[Bool]] {
        scene.spotLights.count.exclusiveON.map { i in
            let cameraTransform = scene.uniforms[scene.spotLights[i].idx.int].modelMatrixInverse
            let cameraBoundingBox = interactor.multiply(cameraTransform, scene.spotLights[i].boundingBox)
            let cameraAlignedBoundingBox = interactor.aabb(cameraBoundingBox)
            return cullingController.cullingMask(scene: scene,
                                                 boundingBox: cameraAlignedBoundingBox)
        }
    }
    private func generateCameraRenderMask(scene: PNSceneDescription) -> [[Bool]] {
        scene.cameraUniforms.indices.map { cameraUniformIndex in
            let cameraUniform = scene.cameraUniforms[cameraUniformIndex]
            let cameraTransform = scene.uniforms[cameraUniform.index.int].modelMatrixInverse
            let cameraBoundingBox = interactor.multiply(cameraTransform, scene.cameras[cameraUniformIndex].boundingBox)
            let cameraAlignedBoundingBox = interactor.aabb(cameraBoundingBox)
            return cullingController.cullingMask(scene: scene,
                                                 boundingBox: cameraAlignedBoundingBox)
        }
    }
    private func generateRenderMasks(scene: PNSceneDescription) -> [[[Bool]]] {
        scene.omniLights.count.exclusiveON.map { lightIndex in
            6.exclusiveON.map { faceIndex in
                let entityIndex = scene.omniLights[lightIndex].idx.int
                let cameraTransform = scene.uniforms[entityIndex].modelMatrixInverse
                let projectionInverse = scene.omniLights[lightIndex].projectionMatrixInverse
                let boundingBox = interactor.from(inverseProjection: projectionInverse)
                let cameraBoundingBox = interactor.multiply(PNSurroundings[faceIndex],
                                                            interactor.multiply(cameraTransform, boundingBox))
                let cameraAlignedBoundingBox = interactor.aabb(cameraBoundingBox)
                return cullingController.cullingMask(scene: scene,
                                                     boundingBox: cameraAlignedBoundingBox)
            }
        }
    }
}

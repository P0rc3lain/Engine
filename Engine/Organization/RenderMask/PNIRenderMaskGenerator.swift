//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIRenderMaskGenerator: PNRenderMaskGenerator {
    private let cullingController: PNCullingController
    private let interactor: PNBoundingBoxInteractor
    private let cubeRotations = simd_quatf.environment
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
        return scene.spotLights.count.naturalExclusive.map { i in
            let cameraTransform = scene.uniforms[Int(scene.spotLights[i].idx)].modelMatrixInverse
            let cameraBoundingBox = interactor.multiply(cameraTransform, scene.spotLights[i].boundingBox)
            let cameraAlignedBoundingBox = interactor.aabb(cameraBoundingBox)
            let mask = cullingController.cullingMask(scene: scene,
                                                     boundingBox: cameraAlignedBoundingBox)
            return mask
        }
    }
    private func generateCameraRenderMask(scene: PNSceneDescription) -> [[Bool]] {
        return scene.cameras.indices.map { index in
            let cameraTransform = scene.uniforms[index].modelMatrixInverse
            let cameraBoundingBox = interactor.multiply(cameraTransform, scene.cameras[index].boundingBox)
            let cameraAlignedBoundingBox = interactor.aabb(cameraBoundingBox)
            return cullingController.cullingMask(scene: scene,
                                                 boundingBox: cameraAlignedBoundingBox)
        }
    }
    private func generateRenderMasks(scene: PNSceneDescription) -> [[[Bool]]] {
        return scene.omniLights.count.naturalExclusive.map { lightIndex in
            var faceData = [[Bool]]()
            for faceIndex in 6.naturalExclusive {
                let entityIndex = Int(scene.omniLights[lightIndex].idx)
                let cameraTransform = scene.uniforms[entityIndex].modelMatrixInverse
                let boundingBox = interactor.from(inverseProjection: scene.omniLights[lightIndex].projectionMatrixInverse)
                let cameraBoundingBox = interactor.multiply(cubeRotations[faceIndex].rotationMatrix,
                                                            interactor.multiply(cameraTransform, boundingBox))
                let cameraAlignedBoundingBox = interactor.aabb(cameraBoundingBox)
                let mask = cullingController.cullingMask(scene: scene,
                                                         boundingBox: cameraAlignedBoundingBox)
                faceData.append(mask)
            }
            return faceData
        }
    }
}

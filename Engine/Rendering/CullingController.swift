//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

struct CullingController {
    let camera: Camera
    let cameraIdx: Int
    init(camera: Camera, cameraIdx: Int) {
        self.camera = camera
        self.cameraIdx = cameraIdx
    }
    static func cullingMask(scene: inout GPUSceneDescription,
                            transformedEntities: [ModelUniforms],
                            camera: Camera,
                            cameraTransfrom: ModelUniforms) -> [Bool] {
        let cameraBB = camera.boundingBox
        let transformedCamera = (cameraTransfrom.modelMatrixInverse * cameraBB).aabb
        var mask = [Bool](minimalCapacity: scene.entities.count)
        for i in scene.entities.indices {
            if scene.entities[i].data.type == .mesh {
                let meshBox = scene.meshBoundingBoxes[scene.entities[i].data.referenceIdx]
                let transformedMesh = (transformedEntities[i].modelMatrix * meshBox).aabb
                mask.append(transformedCamera.overlap(transformedMesh))
            } else {
                mask.append(true)
            }
        }
        return mask
    }
}

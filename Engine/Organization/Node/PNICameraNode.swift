//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public struct PNICameraNode: PNCameraNode {
    public var camera: PNCamera
    public var transform: PNAnimatedCoordinateSpace
    public init(camera: PNCamera, transform: PNAnimatedCoordinateSpace) {
        self.camera = camera
        self.transform = transform
    }
    public func write(scene: inout PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        scene.entities.add(parentIdx: parentIdx, data: PNEntity(type: .camera,
                                                                referenceIdx: scene.cameras.count))
        scene.skeletonReferences.append(.nil)
        scene.cameras.append(camera)
        let uniform = CameraUniforms(projectionMatrix: camera.projectionMatrix,
                                     index: Int32(scene.entities.count - 1))
        scene.cameraUniforms.append(uniform)
        scene.activeCameraIdx = scene.entities.count - 1
        return scene.entities.count - 1
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public final class PNIAnimatedCameraNode: PNAnimatedCameraNode {
    public var camera: PNCamera
    public var animator: PNAnimator
    public var animation: PNAnimatedCoordinateSpace
    public let transform: PNSubject<PNTransform>
    public init(camera: PNCamera,
                animator: PNAnimator,
                animation: PNAnimatedCoordinateSpace) {
        self.camera = camera
        self.animator = animator
        self.animation = animation
        self.transform = PNSubject(animator.transform(coordinateSpace: animation))
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
        scene.entities.add(parentIdx: parentIdx, data: PNEntity(type: .camera,
                                                                referenceIdx: scene.cameras.count))
        scene.cameras.append(camera)
        let uniform = CameraUniforms(projectionMatrix: camera.projectionMatrix,
                                     index: Int32(scene.entities.count - 1))
        scene.cameraUniforms.append(uniform)
        scene.activeCameraIdx = scene.entities.count - 1
        return scene.entities.count - 1
    }
    public func update() {
        let t = animator.transform(coordinateSpace: animation)
        transform.send(t)
    }
}

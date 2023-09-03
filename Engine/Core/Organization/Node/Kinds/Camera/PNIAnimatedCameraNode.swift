//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Combine
import PNShared

public final class PNIAnimatedCameraNode: PNAnimatedCameraNode {
    public let name: String
    public var camera: PNCamera
    public var animator: PNAnimator
    public var animation: PNAnimatedCoordinateSpace
    public let transform: PNSubject<PNLTransform>
    public let worldTransform: PNSubject<PNM2WTransform>
    public let enclosingNode: PNScenePieceSubject
    public let modelUniforms: PNSubject<PNWModelUniforms>
    public let localBoundingBox: PNSubject<PNBoundingBox?>
    public let worldBoundingBox: PNSubject<PNBoundingBox?>
    public let childrenMergedBoundingBox: PNSubject<PNBoundingBox?>
    public let intrinsicBoundingBox: PNBoundingBox?
    private let refreshController = PNIRefreshController()
    public init(camera: PNCamera,
                animator: PNAnimator,
                animation: PNAnimatedCoordinateSpace,
                name: String = "") {
        self.name = name
        self.camera = camera
        self.animator = animator
        self.animation = animation
        self.transform = PNSubject(animator.transform(coordinateSpace: animation))
        self.worldTransform = PNSubject(.identity)
        self.enclosingNode = PNSubject(PNWeakRef(nil))
        self.modelUniforms = PNSubject(.identity)
        self.localBoundingBox = PNSubject(nil)
        self.worldBoundingBox = PNSubject(nil)
        self.childrenMergedBoundingBox = PNSubject(nil)
        self.intrinsicBoundingBox = camera.boundingBox
        self.refreshController.setup(self)
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
        scene.entities.add(parentIdx: parentIdx, data: PNEntity(type: .camera,
                                                                referenceIdx: scene.cameras.count))
        scene.cameras.append(camera)
        let uniform = CameraUniforms(projectionMatrix: camera.projection.mat,
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

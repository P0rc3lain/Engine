//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

public final class PNICameraNode: PNCameraNode {
    public var camera: PNCamera
    public let transform: PNSubject<PNLTransform>
    public let enclosingNode: PNScenePieceSubject
    public init(camera: PNCamera,
                transform: PNLTransform) {
        self.camera = camera
        self.transform = PNSubject(transform)
        self.enclosingNode = PNSubject(PNWeakRef(nil))
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
        // Empty
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared

public final class PNICameraNode: PNCameraNode {
    public let name: String
    public let camera: PNCamera
    public var transform: PNLTransform
    public var worldTransform: PNM2WTransform
    public weak var enclosingNode: PNScenePiece?
    public var modelUniforms: PNWModelUniforms
    public var localBoundingBox: PNBoundingBox?
    public var worldBoundingBox: PNBoundingBox?
    public var childrenMergedBoundingBox: PNBoundingBox?
    public let intrinsicBoundingBox: PNBoundingBox?
    
    public init(camera: PNCamera,
                transform: PNLTransform,
                name: String = "") {
        self.name = name
        self.camera = camera
        self.transform = transform
        self.worldTransform = .identity
        self.enclosingNode = nil
        self.modelUniforms = .identity
        self.localBoundingBox = nil
        self.worldBoundingBox = nil
        self.intrinsicBoundingBox = camera.boundingBox
        self.childrenMergedBoundingBox = nil
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

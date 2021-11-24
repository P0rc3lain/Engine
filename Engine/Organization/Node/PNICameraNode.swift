//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNICameraNode: PNCameraNode {
    public var camera: PNCamera
    public var transform: PNAnimatedCoordinateSpace
    public init(camera: PNCamera, transform: PNAnimatedCoordinateSpace) {
        self.camera = camera
        self.transform = transform
    }
    public func write(scene: inout PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        scene.entities.add(parentIdx: parentIdx, data: Entity(transform: transform,
                                                              type: .camera,
                                                              referenceIdx: scene.cameras.count))
        scene.skeletonReferences.append(.nil)
        scene.cameras.append(camera)
        scene.activeCameraIdx = scene.entities.count - 1
        return scene.entities.count - 1
    }
}

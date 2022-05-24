//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public final class PNIAnimatedMeshNode: PNAnimatedMeshNode {
    public var mesh: PNMesh
    public var animator: PNAnimator
    public var animation: PNAnimatedCoordinateSpace
    public var transform: PNTransform {
        animator.transform(coordinateSpace: animation)
    }
    public init(mesh: PNMesh, animator: PNAnimator, animation: PNAnimatedCoordinateSpace) {
        self.mesh = mesh
        self.animator = animator
        self.animation = animation
    }
    public func write(scene: PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .mesh,
                              referenceIdx: scene.models.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        let modelReference = PNModelReference(mesh: scene.meshes.count,
                                              idx: scene.entities.count - 1)
        scene.models.append(modelReference)
        scene.meshes.append(mesh)
        return scene.entities.count - 1
    }
}

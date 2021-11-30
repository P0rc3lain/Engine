//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public class PNIAnimatedRiggedMesh: PNAnimatedRiggedMesh {
    public var mesh: PNMesh
    public var skeleton: PNSkeleton
    public var animator: PNAnimator
    public var animation: PNAnimatedCoordinateSpace
    public var transform: PNTransform {
        animator.transform(coordinateSpace: animation)
    }
    public init(mesh: PNMesh,
                skeleton: PNSkeleton,
                animator: PNAnimator,
                animation: PNAnimatedCoordinateSpace) {
        self.mesh = mesh
        self.skeleton = skeleton
        self.animator = animator
        self.animation = animation
    }
    public func write(scene: PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .mesh,
                              referenceIdx: scene.meshes.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.meshes.append(mesh)
        scene.skeletons.append(skeleton)
        scene.skeletonReferences.append(scene.skeletons.count - 1)
        return scene.entities.count - 1
    }
}

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
        let entity = PNEntity(type: .animatedMesh,
                              referenceIdx: scene.animatedModels.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        let modelReference = PNAnimatedModelReference(skeleton: scene.skeletons.count,
                                                      mesh: scene.meshes.count,
                                                      idx: scene.entities.count - 1)
        scene.animatedModels.append(modelReference)
        scene.meshes.append(mesh)
        scene.skeletons.append(skeleton)
        return scene.entities.count - 1
    }
}

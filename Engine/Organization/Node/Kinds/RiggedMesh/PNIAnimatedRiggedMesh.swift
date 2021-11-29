//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

struct PNIAnimatedRiggedMesh: PNAnimatedRiggedMesh {
    var mesh: PNMesh
    var skeleton: PNSkeleton
    var animator: PNAnimator
    var animation: PNAnimatedCoordinateSpace
    var transform: PNTransform {
        animator.transform(coordinateSpace: animation)
    }
    func write(scene: PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .mesh,
                              referenceIdx: scene.meshes.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.meshes.append(mesh)
        scene.skeletons.append(skeleton)
        scene.skeletonReferences.append(scene.skeletons.count - 1)
        return scene.entities.count - 1
    }
}

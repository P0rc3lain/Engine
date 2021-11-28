//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

struct PNIAnimatedMeshNode: PNAnimatedMeshNode {
    var mesh: PNMesh
    var animator: PNAnimator
    var animation: PNAnimatedCoordinateSpace
    var transform: PNTransform {
        animator.transform(coordinateSpace: animation)
    }
    func write(scene: inout PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .mesh,
                              referenceIdx: scene.meshes.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.skeletonReferences.append(.nil)
        scene.meshes.append(mesh)
        return scene.entities.count - 1
    }
}

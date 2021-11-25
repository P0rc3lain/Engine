//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

struct PNIRiggedMesh: PNRiggedMesh {
    var mesh: PNMesh
    var skeleton: PNSkeleton
    var transform: PNAnimatedCoordinateSpace
    func write(scene: inout PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .mesh,
                              referenceIdx: scene.meshes.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.meshes.append(mesh)
        scene.skeletons.append(skeleton)
        scene.skeletonReferences.append(scene.skeletons.count - 1)
        return scene.entities.count - 1
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

struct PNIMeshNode: PNMeshNode {
    var mesh: PNMesh
    var transform: PNAnimatedCoordinateSpace
    func write(scene: inout PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .mesh,
                              referenceIdx: scene.meshes.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.skeletonReferences.append(.nil)
        scene.meshes.append(mesh)
        return scene.entities.count - 1
    }
}

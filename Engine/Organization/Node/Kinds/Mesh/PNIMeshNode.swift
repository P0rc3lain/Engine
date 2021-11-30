//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public class PNIMeshNode: PNMeshNode {
    public var mesh: PNMesh
    public var transform: PNTransform
    public init(mesh: PNMesh, transform: PNTransform) {
        self.mesh = mesh
        self.transform = transform
    }
    public func write(scene: PNSceneDescription, parentIdx: PNIndex) -> PNIndex {
        let entity = PNEntity(type: .mesh,
                              referenceIdx: scene.meshes.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.skeletonReferences.append(.nil)
        scene.meshes.append(mesh)
        return scene.entities.count - 1
    }
}

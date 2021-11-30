//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public class PNIRiggedMesh: PNRiggedMesh {
    public var mesh: PNMesh
    public var skeleton: PNSkeleton
    public var transform: PNTransform
    public init(mesh: PNMesh, skeleton: PNSkeleton, transform: PNTransform) {
        self.mesh = mesh
        self.skeleton = skeleton
        self.transform = transform
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

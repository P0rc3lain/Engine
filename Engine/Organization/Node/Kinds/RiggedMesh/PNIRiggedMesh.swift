//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public final class PNIRiggedMesh: PNRiggedMesh {
    public var mesh: PNMesh
    public var skeleton: PNSkeleton
    public let transform: PNSubject<PNTransform>
    public init(mesh: PNMesh,
                skeleton: PNSkeleton,
                transform: PNTransform) {
        self.mesh = mesh
        self.skeleton = skeleton
        self.transform = PNSubject(transform)
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
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
    public func update() {
        // Empty
    }
}

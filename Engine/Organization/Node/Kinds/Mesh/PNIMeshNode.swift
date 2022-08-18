//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public final class PNIMeshNode: PNMeshNode {
    public var mesh: PNMesh
    public let transform: PNSubject<PNLTransform>
    public let worldTransform: PNSubject<PNM2WTransform>
    public let enclosingNode: PNScenePieceSubject
    public let modelUniforms: PNSubject<WModelUniforms>
    public let boundingBox: PNSubject<PNBoundingBox?>
    private let refreshController = PNIRefreshController()
    public init(mesh: PNMesh,
                transform: PNLTransform) {
        self.mesh = mesh
        self.transform = PNSubject(transform)
        self.worldTransform = PNSubject(.identity)
        self.enclosingNode = PNSubject(PNWeakRef(nil))
        self.modelUniforms = PNSubject(.identity)
        self.boundingBox = PNSubject(nil)
        self.refreshController.setup(self)
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
        let entity = PNEntity(type: .mesh,
                              referenceIdx: scene.models.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        let modelReference = PNModelReference(mesh: scene.meshes.count,
                                              idx: scene.entities.count - 1)
        scene.models.append(modelReference)
        scene.meshes.append(mesh)
        return scene.entities.count - 1
    }
    public func update() {
        // Empty
    }
}

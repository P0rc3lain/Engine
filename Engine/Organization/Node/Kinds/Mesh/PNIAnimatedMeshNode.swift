//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public final class PNIAnimatedMeshNode: PNAnimatedMeshNode {
    public var mesh: PNMesh
    public var animator: PNAnimator
    public var animation: PNAnimatedCoordinateSpace
    public let transform: PNSubject<PNLTransform>
    public let worldTransform: PNSubject<PNM2WTransform>
    public let enclosingNode: PNScenePieceSubject
    public let modelUniforms: PNSubject<WModelUniforms>
    private let refreshController = PNIRefreshController()
    public init(mesh: PNMesh,
                animator: PNAnimator,
                animation: PNAnimatedCoordinateSpace) {
        self.mesh = mesh
        self.animator = animator
        self.animation = animation
        self.transform = PNSubject(animator.transform(coordinateSpace: animation))
        self.worldTransform = PNSubject(.identity)
        self.enclosingNode = PNSubject(PNWeakRef(nil))
        self.modelUniforms = PNSubject(.identity)
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
        let t = animator.transform(coordinateSpace: animation)
        transform.send(t)
    }
}

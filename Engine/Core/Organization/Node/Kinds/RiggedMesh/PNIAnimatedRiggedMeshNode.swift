//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public final class PNIAnimatedRiggedMeshNode: PNAnimatedRiggedMeshNode {
    public let name: String
    public let mesh: PNMesh
    public var skeleton: PNSkeleton
    public var animator: PNAnimator
    public var animation: PNAnimatedCoordinateSpace
    public let transform: PNSubject<PNLTransform>
    public let worldTransform: PNSubject<PNM2WTransform>
    public let enclosingNode: PNScenePieceSubject
    public let modelUniforms: PNSubject<PNWModelUniforms>
    public let localBoundingBox: PNSubject<PNBoundingBox?>
    public let worldBoundingBox: PNSubject<PNBoundingBox?>
    public let childrenMergedBoundingBox: PNSubject<PNBoundingBox?>
    public let intrinsicBoundingBox: PNBoundingBox?
    private let refreshController = PNIRefreshController()
    public init(mesh: PNMesh,
                skeleton: PNSkeleton,
                animator: PNAnimator,
                animation: PNAnimatedCoordinateSpace,
                name: String = "") {
        self.name = name
        self.mesh = mesh
        self.skeleton = skeleton
        self.animator = animator
        self.animation = animation
        self.transform = PNSubject(animator.transform(coordinateSpace: animation))
        self.worldTransform = PNSubject(.identity)
        self.enclosingNode = PNSubject(PNWeakRef(nil))
        self.modelUniforms = PNSubject(.identity)
        self.localBoundingBox = PNSubject(nil)
        self.worldBoundingBox = PNSubject(nil)
        self.childrenMergedBoundingBox = PNSubject(nil)
        self.intrinsicBoundingBox = mesh.boundingBox
        self.refreshController.setup(self)
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
        let t = animator.transform(coordinateSpace: animation)
        transform.send(t)
    }
}

//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Combine
import PNShared
import simd

public final class PNIParticleNode: PNParticleNode {
    public let name: String
    public var provider: PNRenderableParticlesProvider
    public let transform: PNSubject<PNLTransform>
    public let worldTransform: PNSubject<PNM2WTransform>
    public let enclosingNode: PNScenePieceSubject
    public let modelUniforms: PNSubject<PNWModelUniforms>
    public let localBoundingBox: PNSubject<PNBoundingBox?>
    public let worldBoundingBox: PNSubject<PNBoundingBox?>
    public let childrenMergedBoundingBox: PNSubject<PNBoundingBox?>
    public var intrinsicBoundingBox: PNBoundingBox? {
        PNIBoundingBoxInteractor.default.from(bound: provider.positioningRules.bound)
    }
    private let refreshController = PNIRefreshController()
    public init(provider: PNRenderableParticlesProvider,
                transform: PNLTransform,
                name: String = "") {
        self.name = name
        self.provider = provider
        self.transform = PNSubject(transform)
        self.worldTransform = PNSubject(.identity)
        self.enclosingNode = PNSubject(PNWeakRef(nil))
        self.modelUniforms = PNSubject(.identity)
        self.localBoundingBox = PNSubject(nil)
        self.worldBoundingBox = PNSubject(nil)
        self.childrenMergedBoundingBox = PNSubject(nil)
        self.refreshController.setup(self)
    }
    public func write(scene: PNSceneDescription, parentIdx: PNParentIndex) -> PNNewlyWrittenIndex {
        let entity = PNEntity(type: .particle,
                              referenceIdx: scene.particles.count)
        scene.entities.add(parentIdx: parentIdx, data: entity)
        scene.particles.append(PNParticleSystem(index: scene.entities.count - 1,
                                                atlas: provider.atlas,
                                                particles: provider.provider,
                                                positioningRules: provider.positioningRules))
        return scene.entities.count - 1
    }
    public func update() {
        // Empty
    }
}

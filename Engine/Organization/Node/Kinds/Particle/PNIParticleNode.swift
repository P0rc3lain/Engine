//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public final class PNIParticleNode: PNParticleNode {
    public var provider: PNRenderableParticlesProvider
    public let transform: PNSubject<PNLTransform>
    public init(provider: PNRenderableParticlesProvider,
                transform: PNLTransform) {
        self.provider = provider
        self.transform = PNSubject(transform)
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

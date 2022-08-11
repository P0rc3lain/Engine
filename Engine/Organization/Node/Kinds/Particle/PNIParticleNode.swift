//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public final class PNIParticleNode: PNParticleNode {
    public var provider: PNRenderableParticlesProvider
    public var transform: PNTransform
    public init(provider: PNRenderableParticlesProvider,
                transform: PNTransform) {
        self.provider = provider
        self.transform = transform
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
}

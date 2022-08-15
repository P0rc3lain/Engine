//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Foundation
import Metal
import MetalBinding

public class PNParticleGenerator: PNRenderableParticlesProvider, PNTask {
    private let emitter: PNEmitter
    private let controller: PNParticleController
    public let atlas: PNTextureAtlas
    private let rules: PNEmissionRules
    private var particles = [PNParticle]()
    private var frozenParticles: [FrozenParticle] {
        particles.map {
            FrozenParticle(position: $0.position,
                           life: $0.life,
                           lifespan: $0.lifespan,
                           scale: $0.scale)
        }
    }
    public var positioningRules: PNPositioningRules {
        rules.position
    }
    private let emissionRate: Int
    public var provider: PNAnyDynamicBuffer<FrozenParticle>
    public var previousUpdate = Date()
    public init?(device: MTLDevice,
                 atlas: PNTextureAtlas,
                 emitter: PNEmitter,
                 emissionRate: Int,
                 rules: PNEmissionRules,
                 controller: PNParticleController) {
        guard let buffer = PNIDynamicBuffer<FrozenParticle>(device: device) else {
            return nil
        }
        self.emitter = emitter
        self.provider = PNAnyDynamicBuffer(buffer)
        self.emissionRate = emissionRate
        self.atlas = atlas
        self.rules = rules
        self.controller = controller
    }
    public func execute() -> Bool {
        let now = Date()
        let delta = now.timeIntervalSince1970 - previousUpdate.timeIntervalSince1970
        var newParticles = controller.updated(particles: particles,
                                              timeSincePreviousUpdate: delta)
        for _ in emissionRate.exclusiveON {
            newParticles.append(emitter.emit(rules: rules))
        }
        provider.upload(data: frozenParticles)
        particles = newParticles
        previousUpdate = Date()
        return true
    }
}

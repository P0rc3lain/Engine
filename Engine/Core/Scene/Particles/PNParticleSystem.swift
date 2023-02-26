//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared

/// Defines a particle system when used in ``PNEntityTree``.
public struct PNParticleSystem {
    let index: PNIndex
    let atlas: PNTextureAtlas
    let particles: PNAnyDynamicBuffer<FrozenParticle>
    let positioningRules: PNPositioningRules
}

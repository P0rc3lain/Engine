//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared

public struct PNParticleSystem {
    let index: PNIndex
    let atlas: PNTextureAtlas
    let particles: PNAnyDynamicBuffer<FrozenParticle>
    let positioningRules: PNPositioningRules
}

//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared

/// Capable of returning particles prepared for rendering on a GPU.
public protocol PNRenderableParticlesProvider {
    var provider: PNAnyDynamicBuffer<FrozenParticle> { get }
    var atlas: PNTextureAtlas { get }
    var positioningRules: PNPositioningRules { get }
}

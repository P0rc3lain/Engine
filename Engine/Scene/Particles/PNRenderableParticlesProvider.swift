//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

public protocol PNRenderableParticlesProvider {
    var provider: PNAnyDynamicBuffer<FrozenParticle> { get }
    var atlas: PNTextureAtlas { get }
    var positioningRules: PNPositioningRules { get }
}

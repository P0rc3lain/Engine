//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

/// Performs state update.
public protocol PNParticleController {
    func updated(particles: [PNParticle],
                 timeSincePreviousUpdate: TimeInterval) -> [PNParticle]
}

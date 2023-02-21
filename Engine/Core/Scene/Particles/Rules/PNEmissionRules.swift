//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

/// A set of restruction that should be followed while creating new particles.
public struct PNEmissionRules {
    public let lifespan: ClosedRange<Float>
    public let speed: ClosedRange<Float>
    public let scale: ClosedRange<Float>
    public let position: PNPositioningRules
    public init(lifespan: ClosedRange<Float>,
                speed: ClosedRange<Float>,
                scale: ClosedRange<Float>,
                position: PNPositioningRules) {
        self.lifespan = lifespan
        self.speed = speed
        self.scale = scale
        self.position = position
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIDirectionalLight: PNDirectionalLight {
    public let color: PNColorRGB
    public let intensity: Float
    public let direction: PNDirection3DN
    public let castsShadows: Bool
    public init(color: PNColorRGB,
                intensity: Float,
                direction: PNDirection3DN,
                castsShadows: Bool) {
        self.color = color
        self.intensity = intensity
        self.direction = direction
        self.castsShadows = castsShadows
    }
}

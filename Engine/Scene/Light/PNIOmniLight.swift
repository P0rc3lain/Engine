//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIOmniLight: PNOmniLight {
    public var color: PNColorRGB
    public var intensity: Float
    public var castsShadows: Bool
    public init(color: PNColorRGB, intensity: Float, castsShadows: Bool) {
        self.color = color
        self.intensity = intensity
        self.castsShadows = castsShadows
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNISpotLight: PNSpotLight {
    public var color: PNColorRGB
    public var intensity: Float
    public var coneAngle: Radians
    public var castsShadows: Bool
    public init(color: PNColorRGB,
                intensity: Float,
                coneAngle: Radians,
                castsShadows: Bool) {
        self.color = color
        self.intensity = intensity
        self.coneAngle = coneAngle
        self.castsShadows = castsShadows
    }
}

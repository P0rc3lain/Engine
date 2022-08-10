//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNISpotLight: PNSpotLight {
    public var color: PNColorRGB
    public var intensity: Float
    public var coneAngle: Radians
    public init(color: PNColorRGB,
                intensity: Float,
                coneAngle: Radians) {
        self.color = color
        self.intensity = intensity
        self.coneAngle = coneAngle
    }
}

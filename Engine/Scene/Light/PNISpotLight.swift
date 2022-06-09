//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNISpotLight: PNSpotLight {
    public var color: simd_float3
    public var intensity: Float
    public var coneAngle: Float
    // Angle measured in radians
    public init(color: simd_float3, intensity: Float, coneAngle: Float) {
        self.color = color
        self.intensity = intensity
        self.coneAngle = coneAngle
    }
}

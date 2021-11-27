//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIAmbientLight: PNAmbientLight {
    public var diameter: Float
    public var color: simd_float3
    public var intensity: Float
    public init(diameter: Float, color: simd_float3, intensity: Float) {
        self.diameter = diameter
        self.color = color
        self.intensity = intensity
    }
}

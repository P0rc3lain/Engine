//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIOmniLight: PNOmniLight {
    public var color: simd_float3
    public var intensity: Float
    public init(color: simd_float3, intensity: Float) {
        self.color = color
        self.intensity = intensity
    }
}

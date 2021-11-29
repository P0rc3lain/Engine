//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIDirectionalLight: PNDirectionalLight {
    public var color: simd_float3
    public var intensity: Float
    public var direction: simd_float3
    public init(color: simd_float3, intensity: Float, direction: simd_float3) {
        self.color = color
        self.intensity = intensity
        self.direction = direction
    }
}

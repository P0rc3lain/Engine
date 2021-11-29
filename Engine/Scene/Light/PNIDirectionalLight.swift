//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIDirectionalLight: PNDirectionalLight {
    public let orientation: simd_float3x3
    public let color: simd_float3
    public let intensity: Float
    public let direction: simd_float3
    public init(color: simd_float3, intensity: Float, direction: simd_float3) {
        self.color = color
        self.intensity = intensity
        self.direction = direction
        self.orientation = .from(directionVector: direction)
    }
}

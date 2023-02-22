//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

/// Small, localized object that can be described by several physical properties.
public struct PNParticle {
    public var position: simd_float3
    public var speed: Float
    public var maximumSpeed: Float
    public var direction: simd_float3
    public var life: Float
    public var lifespan: Float
    public var scale: Float
    public var maximumScale: Float
    public init(position: simd_float3,
                speed: Float,
                maximumSpeed: Float,
                direction: simd_float3,
                life: Float,
                lifespan: Float,
                scale: Float,
                maximumScale: Float) {
        self.position = position
        self.speed = speed
        self.maximumSpeed = maximumSpeed
        self.direction = direction
        self.life = life
        self.lifespan = lifespan
        self.scale = scale
        self.maximumScale = maximumScale
    }
}

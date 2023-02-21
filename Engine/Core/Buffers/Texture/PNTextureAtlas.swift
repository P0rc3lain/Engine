//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

/// A texture atlas is an image that contains data from several smaller images that have been packed together.
public struct PNTextureAtlas {
    public let texture: MTLTexture
    public let grid: simd_uint2
    public let useableTiles: UInt
    public init(texture: MTLTexture,
                grid: simd_uint2,
                useableTiles: UInt) {
        self.texture = texture
        self.grid = grid
        self.useableTiles = useableTiles
    }
}

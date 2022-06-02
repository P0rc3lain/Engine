//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

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

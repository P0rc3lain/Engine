//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

/// This struct represents a grid-based atlas, storing the underlying Metal texture, the grid layout, and the number of usable tiles.
public struct PNTextureAtlas {
    /// The Metal texture resource containing the packed atlas image.
    public let texture: MTLTexture
    /// The grid size of the atlas as columns (x) and rows (y). Each grid cell contains a tile.
    /// Example: `(4, 4)` means the atlas is divided into 4 columns and 4 rows, for up to 16 tiles.
    public let grid: simd_uint2
    /// The number of tiles in the atlas that are considered usable (not reserved or empty).
    public let useableTiles: UInt
    /// Initializes a new texture atlas wrapper.
    /// - Parameters:
    ///   - texture: The Metal texture containing the atlas image data.
    ///   - grid: The grid layout (columns, rows) specifying tile arrangement.
    ///   - useableTiles: The number of tiles in the atlas that are usable.
    public init(texture: MTLTexture,
                grid: simd_uint2,
                useableTiles: UInt) {
        self.texture = texture
        self.grid = grid
        self.useableTiles = useableTiles
    }
}

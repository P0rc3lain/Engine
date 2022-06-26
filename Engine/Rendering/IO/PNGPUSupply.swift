//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

struct PNGPUSupply {
    static var empty: PNGPUSupply {
        PNGPUSupply(color: [PNTextureProvider](), stencil: [], depth: [])
    }
    let color: [PNTextureProvider]
    let stencil: [PNTextureProvider]
    let depth: [PNTextureProvider]
    init(color: [PNTextureProvider] = [],
         stencil: [PNTextureProvider] = [],
         depth: [PNTextureProvider] = []) {
        self.color = color
        self.stencil = stencil
        self.depth = depth
    }
    init(color: [MTLTexture] = [],
         stencil: [MTLTexture] = [],
         depth: [MTLTexture] = []) {
        self.color = color.map({ PNStaticTexture($0) })
        self.stencil = stencil.map({ PNStaticTexture($0) })
        self.depth = depth.map({ PNStaticTexture($0) })
    }
}

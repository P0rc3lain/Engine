//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

struct GPUSupply {
    static var empty: GPUSupply {
        GPUSupply(color: [], stencil: [], depth: [])
    }
    let color: [MTLTexture]
    let stencil: [MTLTexture]
    let depth: [MTLTexture]
    init(color: [MTLTexture] = [], stencil: [MTLTexture] = [], depth: [MTLTexture] = []) {
        self.color = color
        self.stencil = stencil
        self.depth = depth
    }
}

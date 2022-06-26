//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

struct PNStaticTexture: PNTextureProvider {
    var texture: MTLTexture?
    init(_ texture: MTLTexture? = nil) {
        self.texture = texture
    }
}

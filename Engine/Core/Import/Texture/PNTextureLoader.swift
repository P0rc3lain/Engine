//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import AppKit
import Metal

/// Conversion of textures to native GPU type.
public protocol PNTextureLoader {
    func load(image: NSImage) -> MTLTexture?
}

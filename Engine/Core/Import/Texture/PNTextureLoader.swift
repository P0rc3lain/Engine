//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import AppKit
import Metal

public protocol PNTextureLoader {
    func load(image: NSImage) -> MTLTexture?
}

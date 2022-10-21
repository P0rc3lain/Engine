//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#if os(macOS)

import AppKit
import Metal

public protocol PNTextureLoader {
    func load(image: NSImage) -> MTLTexture?
}

#endif

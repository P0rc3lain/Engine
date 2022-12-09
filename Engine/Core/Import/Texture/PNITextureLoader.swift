//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#if os(macOS)

import AppKit
import MetalKit

public struct PNITextureLoader: PNTextureLoader {
    private let device: MTLDevice
    public init(device: MTLDevice) {
        self.device = device
    }
    public func load(image: NSImage) -> MTLTexture? {
        guard let cgImage = image.cgImage else {
            assertionFailure("Could not convert NSImage to CGImage")
            return nil
        }
        return try? MTKTextureLoader(device: device).newTexture(cgImage: cgImage)
    }
}

#endif

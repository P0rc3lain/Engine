//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import AppKit
import MetalKit

public struct PNITextureLoader: PNTextureLoader {
    private let device: MTLDevice
    public init(device: MTLDevice) {
        self.device = device
    }
    public func load(image: NSImage) -> MTLTexture? {
        var rect = CGRect(width: image.size.width,
                          height: image.size.height)
        guard let cgImage = image.cgImage(forProposedRect: &rect,
                                          context: nil,
                                          hints: nil) else {
            return nil
        }
        return try? MTKTextureLoader(device: device).newTexture(cgImage: cgImage)
    }
}

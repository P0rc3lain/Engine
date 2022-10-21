//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#if os(macOS)

import AppKit

extension NSImage {
    var cgImage: CGImage? {
        var rect = CGRect(width: size.width,
                          height: size.height)
        return cgImage(forProposedRect: &rect,
                       context: nil,
                       hints: nil)
    }
}

#endif

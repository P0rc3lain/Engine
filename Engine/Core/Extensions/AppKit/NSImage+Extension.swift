//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

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

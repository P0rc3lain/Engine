//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import AppKit

extension NSColor {
    var rgbAverage: CGFloat {
        (redComponent + blueComponent + greenComponent) / 3
    }
}

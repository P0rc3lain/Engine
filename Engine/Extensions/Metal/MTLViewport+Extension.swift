//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLViewport {
    static func porcelain(size: CGSize) -> MTLViewport {
        MTLViewport(originX: 0,
                    originY: 0,
                    width: Double(size.width),
                    height: Double(size.height),
                    znear: 0,
                    zfar: 1)
    }
}

//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

extension MTLTexture {
    var size: MTLSize {
        MTLSize(width: width,
                height: height,
                depth: depth)
    }
}

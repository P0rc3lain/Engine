//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLAxisAlignedBoundingBox {
    var pnBound: PNBound {
        PNBound(min: minBounds, max: maxBounds)
    }
}

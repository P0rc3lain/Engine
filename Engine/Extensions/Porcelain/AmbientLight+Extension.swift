//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension AmbientLight {
    var boundingBox: BoundingBox {
        let radius = diameter/2
        let bound = Bound(min: [-radius, -radius, -radius],
                          max: [radius, radius, radius])
        return BoundingBox.from(bound: bound)
    }
}

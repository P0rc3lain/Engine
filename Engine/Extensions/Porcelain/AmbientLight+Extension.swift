//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension AmbientLight {
    var boundingBox: PNBoundingBox {
        let radius = diameter/2
        let bound = PNBound(min: [-radius, -radius, -radius],
                            max: [radius, radius, radius])
        return PNIBoundingBoxInteractor.default.from(bound: bound)
    }
}

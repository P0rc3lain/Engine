//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLCamera {
    var porcelain: PNCamera {
        PNCamera(nearPlane: nearVisibilityDistance,
                 farPlane: farVisibilityDistance,
                 fovRadians: fieldOfView.radians,
                 aspectRatio: sensorAspect)
    }
}

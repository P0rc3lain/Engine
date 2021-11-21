//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLCamera {
    var porcelain: Camera {
        Camera(name: name,
               nearPlane: nearVisibilityDistance,
               farPlane: farVisibilityDistance,
               fovRadians: fieldOfView.radians,
               aspectRatio: sensorAspect)
    }
}

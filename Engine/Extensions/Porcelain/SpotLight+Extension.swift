//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared

extension SpotLight {
    public static func make(light: PNSpotLight, index: Int) -> SpotLight {
        SpotLight(color: light.color,
                  intensity: light.intensity,
                  influenceRadius: light.influenceRadius,
                  projectionMatrix: light.projectionMatrix,
                  projectionMatrixInverse: light.projectionMatrixInverse,
                  coneAngle: light.coneAngle,
                  idx: Int32(index),
                  castsShadows: light.castsShadows ? 1 : 0)
    }
}

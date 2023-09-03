//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared

extension SpotLight {
    public static func make(light: PNSpotLight, index: Int) -> SpotLight {
        SpotLight(color: light.color,
                  intensity: light.intensity,
                  influenceRadius: light.influenceRadius,
                  projectionMatrix: light.projection.mat,
                  projectionMatrixInverse: light.projection.inv,
                  coneAngle: light.coneAngle,
                  innerConeAngle: light.innerConeAngle,
                  outerConeAngle: light.outerConeAngle,
                  idx: Int32(index),
                  castsShadows: light.castsShadows ? 1 : 0)
    }
}

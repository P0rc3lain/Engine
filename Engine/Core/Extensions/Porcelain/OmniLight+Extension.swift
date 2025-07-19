//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared

extension OmniLight {
    public static func make(light: PNOmniLight,
                            index: Int) -> OmniLight {
        OmniLight(color: light.color,
                  intensity: light.intensity,
                  influenceRadius: light.influenceRadius,
                  idx: Int32(index),
                  projectionMatrix: light.projectionMatrix,
                  projectionMatrixInverse: light.projectionMatrix.inverse,
                  castsShadows: light.castsShadows ? 1 : 0,
                  nearPlane: light.nearPlane,
                  farPlane: light.farPlane)
    }
}

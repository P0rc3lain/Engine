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
                  projectionMatrix: light.projection.mat,
                  projectionMatrixInverse: light.projection.inv,
                  castsShadows: light.castsShadows ? 1 : 0)
    }
}

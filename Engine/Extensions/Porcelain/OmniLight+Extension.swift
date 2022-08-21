//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension OmniLight {
    public static func make(light: PNOmniLight,
                            index: Int) -> OmniLight {
        OmniLight(color: light.color,
                  intensity: light.intensity,
                  idx: Int32(index),
                  projectionMatrix: light.projectionMatrix,
                  projectionMatrixInverse: light.projectionMatrix.inverse,
                  castsShadows: light.castsShadows ? 1 : 0)
    }
}

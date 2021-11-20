//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension AnimatedQuatf {
    static public var defaultOrientation: AnimatedQuatf {
        AnimatedQuatf(keyFrames: [simd_quatf(angle: 0, axis: simd_float3(1, 0, 0))],
                      times: [0],
                      maximumTime: 0)
    }
}

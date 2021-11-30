//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension PNAnimatedQuatf {
    static public var defaultOrientation: PNAnimatedQuatf {
        PNAnimatedQuatf(keyFrames: [simd_quatf(angle: 0, axis: simd_float3(1, 0, 0))],
                        times: [0],
                        maximumTime: 0)
    }
}

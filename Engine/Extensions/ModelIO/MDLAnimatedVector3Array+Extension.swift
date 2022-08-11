//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLAnimatedVector3Array {
    var porcelain: PNAnimatedFloat3Array {
        let times = keyTimes.map { TimeInterval(truncating: $0) }
        let keyFrames = times.map { float3Array(atTime: $0) }
        return PNAnimatedFloat3Array(keyFrames: keyFrames,
                                     times: times,
                                     maximumTime: maximumTime)
    }
}

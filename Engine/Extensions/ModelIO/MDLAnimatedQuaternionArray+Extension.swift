//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLAnimatedQuaternionArray {
    var porcelain: PNAnimatedQuatfArray {
        let times = keyTimes.map { TimeInterval(truncating: $0) }
        let keyFrames = times.map { floatQuaternionArray(atTime: $0) }
        return PNAnimatedQuatfArray(keyFrames: keyFrames, times: times, maximumTime: maximumTime)
    }
}

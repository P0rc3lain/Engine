//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLAnimatedQuaternionArray {
    var porcelain: AnimatedQuatfArray {
        let times = keyTimes.map { TimeInterval(truncating: $0) }
        let keyFrames = times.map { floatQuaternionArray(atTime: $0) }
        return AnimatedQuatfArray(keyFrames: keyFrames, times: times, maximumTime: maximumTime)
    }
}

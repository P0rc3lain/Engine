//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public class PNILoopSampler: PNSampleProvider {
    public func sample<T>(animation: PNKeyframeAnimation<T>,
                          at time: PNTimePoint) -> PNAnimationSample<T> {
        guard animation.times.count > 1 else {
            return PNAnimationSample(currentKeyFrame: animation.keyFrames[0],
                                     upcomingKeyFrame: animation.keyFrames[0],
                                     ratio: 0.5)
        }
        if let keyFrameIndex = animation.times.firstIndex(of: time) {
            return PNAnimationSample(currentKeyFrame: animation.keyFrames[keyFrameIndex],
                                     upcomingKeyFrame: animation.keyFrames[keyFrameIndex],
                                     ratio: 0.5)
        }
        let clipped = time.truncatingRemainder(dividingBy: animation.maximumTime)
        let nextIndex = animation.times.firstIndex { clipped < $0 } ?? 0
        let currentIndex = nextIndex > 0 ? nextIndex - 1 : animation.times.count - 1
        let currentTime = animation.times[currentIndex]
        let nextTime = animation.times[nextIndex]
        let rangeA = nextTime - currentTime
        let rangeB = animation.maximumTime - currentTime + nextTime
        let timeRange = nextTime > 0 ? rangeA : rangeB
        let timePositionA = clipped - currentTime
        let timePositionB = clipped > currentTime ? clipped - currentTime : animation.maximumTime - currentTime + clipped
        let timePosition = nextTime > 0 ? timePositionA : timePositionB
        let ratio = clamp(value: timePosition / timeRange, min: 0, max: 1)
        return PNAnimationSample(currentKeyFrame: animation.keyFrames[currentIndex],
                                 upcomingKeyFrame: animation.keyFrames[nextIndex],
                                 ratio: Float(ratio))
    }
}

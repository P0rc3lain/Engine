//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation

public final class PNIAnimatedValue<T>: PNAnimatedValue {
    public var keyFrames: [T]
    public let times: [TimeInterval]
    public let maximumTime: TimeInterval
    public init(keyFrames: [T], times: [TimeInterval], maximumTime: TimeInterval) {
        assert(times.count == keyFrames.count)
        assert(times.sorted() == times)
        assert(!times.isEmpty)
        assert(times.sorted() == times)
        assert(times[times.count - 1] <= maximumTime)
        self.keyFrames = keyFrames
        self.times = times
        self.maximumTime = maximumTime
    }
    public func sample(at time: TimeInterval) -> PNAnimationSample<T> {
        guard times.count > 1 else {
            return PNAnimationSample(currentKeyFrame: keyFrames[0],
                                     upcomingKeyFrame: keyFrames[0],
                                     ratio: 0.5)
        }
        let clipped = time.truncatingRemainder(dividingBy: maximumTime)
        let next = times.firstIndex { clipped < $0 } ?? 0
        let current = next > 0 ? next - 1 : times.count - 1
        let timeRange = next > 0 ? times[next] - times[current] : maximumTime - times[current] + times[next]
        let timePosition = next > 0 ? clipped - times[current] : (clipped > times[current] ? clipped - times[current] : maximumTime - times[current] + clipped)
        let ratio = clamp(value: timePosition / timeRange, min: 0, max: 1)
        return PNAnimationSample(currentKeyFrame: keyFrames[current],
                                 upcomingKeyFrame: keyFrames[next],
                                 ratio: Float(ratio))
    }
    static public func `static`(from value: T) -> PNIAnimatedValue<T> {
        PNIAnimatedValue<T>(keyFrames: [value], times: [0], maximumTime: 1)
    }
    public func map(_ transform: (T) -> T) {
        keyFrames.inplaceMap(transform: transform)
    }
}

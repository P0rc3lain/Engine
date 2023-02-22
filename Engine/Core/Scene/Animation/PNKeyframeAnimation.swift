//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

/// Action in a digital animation sequence.
/// Define points that later will be interpolated to estimate inbetween values.
public struct PNKeyframeAnimation<T> {
    public var keyFrames: [T]
    public let times: [PNTimePoint]
    public let maximumTime: PNTimeInterval
    public init(keyFrames: [T],
                times: [PNTimePoint],
                maximumTime: PNTimeInterval) {
        assertEqual(times.count, keyFrames.count)
        assertSorted(times)
        assertNotEmpty(times)
        assertGreaterOrEqual(maximumTime, times[times.count - 1])
        self.keyFrames = keyFrames
        self.times = times
        self.maximumTime = maximumTime
    }
    static public func `static`(from value: T) -> PNKeyframeAnimation<T> {
        PNKeyframeAnimation<T>(keyFrames: [value],
                               times: [0],
                               maximumTime: 1)
    }
}

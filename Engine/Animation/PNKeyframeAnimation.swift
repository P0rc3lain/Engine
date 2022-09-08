//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public struct PNKeyframeAnimation<T> {
    public var keyFrames: [T]
    public let times: [PNTimePoint]
    public let maximumTime: PNTimeInterval
    public init(keyFrames: [T],
                times: [PNTimePoint],
                maximumTime: PNTimeInterval) {
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

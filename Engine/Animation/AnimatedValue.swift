//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Foundation

public struct AnimatedValue<T> {
    // MARK: - Properties
    private var keyFrames: [T]
    private let times: [TimeInterval]
    private let maximumTime: TimeInterval
    var keyTimes: [TimeInterval] {
        times
    }
    // MARK: - Initialization
    public init(keyFrames: [T], times: [TimeInterval], maximumTime: TimeInterval) {
        assert(times.count == keyFrames.count)
        assert(times.sorted() == times)
        assert(!times.isEmpty)
        self.keyFrames = keyFrames
        self.times = times
        self.maximumTime = maximumTime
    }
    // MARK: - Public
    public func sample(at time: TimeInterval) -> AnimationSample<T> {
        guard times.count > 1 else {
            return AnimationSample(currentKeyFrame: keyFrames[0],
                                   upcomingKeyFrame: keyFrames[0],
                                   ratio: 0.5)
        }
        let clipped = time.truncatingRemainder(dividingBy: maximumTime)
        let next = times.firstIndex { clipped < $0 } ?? 0
        let current = next > 0 ? next - 1 : times.count - 1
        let timeRange = next > 0 ? times[next] - times[current] : maximumTime - times[current] + times[next]
        let timePosition = next > 0 ? time - times[current] : (time > times[current] ? time - times[current] : maximumTime - times[current] + time)
        let ratio = (timePosition / timeRange).clamp(min: 0.0, max: 1.0)
        return AnimationSample(currentKeyFrame: keyFrames[current],
                               upcomingKeyFrame: keyFrames[next],
                               ratio: Float(ratio))
    }
    static public func `static`(from value: T) -> AnimatedValue<T> {
        AnimatedValue<T>(keyFrames: [value], times: [0], maximumTime: 1)
    }
    public mutating func map(transform: (T) -> T) {
        keyFrames.inplaceMap(transform: transform)
    }
}

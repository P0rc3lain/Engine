//
//  AnimatedValue.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import Foundation

public struct AnimatedValue<T> {
    let keyFrames: [T]
    let times: [TimeInterval]
    let maximumTime: TimeInterval
    
    public init(keyFrames: [T], times: [TimeInterval], maximumTime: TimeInterval) {
        assert(times.count == keyFrames.count)
        assert(times.sorted() == times)
        assert(times.count > 0)
        self.keyFrames = keyFrames
        self.times = times
        self.maximumTime = maximumTime
    }
    
    public func sample(at time: TimeInterval) -> (current: T, upcoming: T, ratio: Float) {
        guard times.count > 1 else {
            return (current: keyFrames[0], upcoming: keyFrames[0], ratio: 0.5)
        }
        let clipped = time.truncatingRemainder(dividingBy: maximumTime)
        let next = times.firstIndex { clipped < $0 } ?? 0
        let current = next > 0 ? next - 1 : times.count - 1
        let timeRange = next > 0 ? times[next] - times[current] : maximumTime - times[current] + times[next]
        let timePosition = next > 0 ? time - times[current] : (time > times[current] ? time - times[current] : maximumTime - times[current] + time)
        let ratio = Float(timePosition / timeRange)
        return (current: keyFrames[current], upcoming: keyFrames[next], ratio: ratio)
    }
}

//
//  AnimatedValue.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import Foundation

public struct AnimatedValue<T> {
    // MARK: - Properties
    private let keyFrames: [T]
    private let times: [TimeInterval]
    private let maximumTime: TimeInterval
    // MARK: - Initialization
    public init(keyFrames: [T], times: [TimeInterval], maximumTime: TimeInterval) {
        assert(times.count == keyFrames.count)
        assert(times.sorted() == times)
        assert(times.count > 0)
        self.keyFrames = keyFrames
        self.times = times
        self.maximumTime = maximumTime
    }
    // MARK: - Public
    public func sample(at time: TimeInterval) -> (current: T, upcoming: T, ratio: Float) {
        guard times.count > 1 else {
            return (current: keyFrames[0], upcoming: keyFrames[0], ratio: 0.5)
        }
        let clipped = time.truncatingRemainder(dividingBy: maximumTime)
        let next = times.firstIndex { clipped < $0 } ?? 0
        let current = next > 0 ? next - 1 : times.count - 1
        let timeRange = next > 0 ? times[next] - times[current] : maximumTime - times[current] + times[next]
        let timePosition = next > 0 ? time - times[current] : (time > times[current] ? time - times[current] : maximumTime - times[current] + time)
        let ratio = (timePosition / timeRange).clamp(min: 0.0, max: 1.0)
        return (current: keyFrames[current], upcoming: keyFrames[next], ratio: Float(ratio))
    }
    static public func `static`(from value: T) -> AnimatedValue<T> {
        return AnimatedValue<T>(keyFrames: [value], times: [0], maximumTime: 1)
    }
}

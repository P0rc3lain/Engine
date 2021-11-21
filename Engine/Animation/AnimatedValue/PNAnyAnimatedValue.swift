//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNAnyAnimatedValue<T>: PNAnimatedValue {
    public typealias DataType = T
    public var keyFrames: [T] {
        keyFramesProxy()
    }
    public var times: [TimeInterval] {
        timesProxy()
    }
    public var maximumTime: TimeInterval {
        maximumTimeProxy()
    }
    private let keyFramesProxy: () -> [T]
    private let timesProxy: () -> [TimeInterval]
    private let maximumTimeProxy: () -> TimeInterval
    private let sampleProxy: (TimeInterval) -> PNAnimationSample<T>
    init<V: PNAnimatedValue>(_ delegatee: V) where V.DataType == T {
        keyFramesProxy = { delegatee.keyFrames }
        timesProxy = { delegatee.times }
        maximumTimeProxy = { delegatee.maximumTime }
        sampleProxy = delegatee.sample(at:)
    }
    public func sample(at time: TimeInterval) -> PNAnimationSample<T> {
        sampleProxy(time)
    }
}

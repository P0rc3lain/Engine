//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public class PNISinglePlaySampler: PNSampleProvider {
    private let loopSampler: PNILoopSampler
    public init() {
        self.loopSampler = PNILoopSampler()
    }
    public func sample<T>(animation: PNKeyframeAnimation<T>,
                          at time: PNTimePoint) -> PNAnimationSample<T> {
        guard let lastKeyframeTimePoint = animation.times.last else {
            fatalError("Times must not be empty")
        }
        let timeClamped = clamp(value: time, min: 0, max: lastKeyframeTimePoint)
        return loopSampler.sample(animation: animation, at: timeClamped)
    }
}

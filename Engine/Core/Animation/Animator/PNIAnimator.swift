//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNIAnimator: PNAnimator {
    public var chronometer: PNChronometer
    public var interpolator: PNInterpolator
    public var sampler: PNSampleProvider
    public var windingOrder: PNTransformationWinding
    public init(chronometer: PNChronometer,
                interpolator: PNInterpolator,
                sampler: PNSampleProvider,
                windingOrder: PNTransformationWinding = .trs) {
        self.chronometer = chronometer
        self.interpolator = interpolator
        self.windingOrder = windingOrder
        self.sampler = sampler
    }
    public func transform(coordinateSpace: PNAnimatedCoordinateSpace) -> PNTransform {
        let time = chronometer.elapsedTime
        let t = interpolator.interpolated(sample: sampler.sample(animation: coordinateSpace.translation, at: time))
        let r = interpolator.interpolated(sample: sampler.sample(animation: coordinateSpace.rotation, at: time))
        let s = interpolator.interpolated(sample: sampler.sample(animation: coordinateSpace.scale, at: time))
        if windingOrder == .trs {
            return .composeTRS(translation: t, rotation: r, scale: s)
        }
        return .composeRTS(translation: t, rotation: r, scale: s)
    }
    public static var `defaultTRS`: PNIAnimator {
        PNIAnimator(chronometer: PNIChronometer(timeProducer: { Date() }),
                    interpolator: PNIInterpolator(),
                    sampler: PNILoopSampler())
    }
    public static var `defaultRTS`: PNIAnimator {
        PNIAnimator(chronometer: PNIChronometer(timeProducer: { Date() }),
                    interpolator: PNIInterpolator(),
                    sampler: PNILoopSampler(),
                    windingOrder: .rts)
    }
}

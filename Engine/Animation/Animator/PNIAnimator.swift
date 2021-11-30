//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNIAnimator: PNAnimator {
    public var chronometer: PNChronometer
    private let interpolator: PNInterpolator
    public init(chronometer: PNChronometer, interpolator: PNInterpolator) {
        self.chronometer = chronometer
        self.interpolator = interpolator
    }
    public func transform(coordinateSpace: PNAnimatedCoordinateSpace) -> PNTransform {
        coordinateSpace.transformation(at: chronometer.elapsedTime, interpolator: interpolator)
    }
    public static var `default`: PNIAnimator {
        PNIAnimator(chronometer: PNIChronometer(timeProducer: { Date() }),
                    interpolator: PNIInterpolator())
    }
}

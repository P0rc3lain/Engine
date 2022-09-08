//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNIAnimator: PNAnimator {
    public var chronometer: PNChronometer
    private let interpolator: PNInterpolator
    private let windingOrder: PNTransformationWinding
    public init(chronometer: PNChronometer,
                interpolator: PNInterpolator,
                windingOrder: PNTransformationWinding = .trs) {
        self.chronometer = chronometer
        self.interpolator = interpolator
        self.windingOrder = windingOrder
    }
    public func transform(coordinateSpace: PNAnimatedCoordinateSpace) -> PNTransform {
        if windingOrder == .trs {
            return coordinateSpace.transformationTRS(at: chronometer.elapsedTime, interpolator: interpolator)
        }
        return coordinateSpace.transformationRTS(at: chronometer.elapsedTime, interpolator: interpolator)
    }
    public static var `defaultTRS`: PNIAnimator {
        PNIAnimator(chronometer: PNIChronometer(timeProducer: { Date() }),
                    interpolator: PNIInterpolator())
    }
    public static var `defaultRTS`: PNIAnimator {
        PNIAnimator(chronometer: PNIChronometer(timeProducer: { Date() }),
                    interpolator: PNIInterpolator(),
                    windingOrder: .rts)
    }
}

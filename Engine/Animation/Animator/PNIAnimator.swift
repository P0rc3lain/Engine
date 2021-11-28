//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

struct PNIAnimator: PNAnimator {
    var chronometer: PNChronometer
    private let interpolator: PNInterpolator
    init(chronometer: PNChronometer, interpolator: PNInterpolator) {
        self.chronometer = chronometer
        self.interpolator = interpolator
    }
    func transform(coordinateSpace: PNAnimatedCoordinateSpace) -> PNTransform {
        coordinateSpace.transformation(at: chronometer.elapsedTime, interpolator: interpolator)
    }
}

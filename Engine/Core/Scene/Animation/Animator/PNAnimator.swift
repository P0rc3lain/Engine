//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Animation coordinator.
/// Based on criterion used takes ``PNKeyframeAnimation`` and returns final transform for a given moment.
public protocol PNAnimator {
    var chronometer: PNChronometer { get set }
    var interpolator: PNInterpolator { get set }
    var sampler: PNSampleProvider { get set }
    var windingOrder: PNTransformationWinding { get set }
    func transform(coordinateSpace: PNAnimatedCoordinateSpace) -> PNTransform
}

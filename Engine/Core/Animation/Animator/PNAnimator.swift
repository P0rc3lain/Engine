//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public protocol PNAnimator {
    var chronometer: PNChronometer { get set }
    var interpolator: PNInterpolator { get set }
    var sampler: PNSampleProvider { get set }
    var windingOrder: PNTransformationWinding { get set }
    func transform(coordinateSpace: PNAnimatedCoordinateSpace) -> PNTransform
}

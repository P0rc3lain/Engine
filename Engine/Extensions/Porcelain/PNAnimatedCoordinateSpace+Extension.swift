//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension PNAnimatedCoordinateSpace {
    func transformation(at time: TimeInterval, interpolator: PNInterpolator) -> simd_float4x4 {
        simd_float4x4.compose(translation: interpolator.interpolated(sample: translation.sample(at: time)),
                              rotation: interpolator.interpolated(sample: rotation.sample(at: time)),
                              scale: interpolator.interpolated(sample: scale.sample(at: time)))
    }
    static public var `static`: PNAnimatedCoordinateSpace {
        PNAnimatedCoordinateSpace(translation: PNAnyAnimatedValue(PNAnimatedFloat3.defaultTranslation),
                                  rotation: PNAnyAnimatedValue(PNAnimatedQuatf.defaultOrientation),
                                  scale: PNAnyAnimatedValue(PNAnimatedFloat3.defaultScale))
    }
    static public func `static`(from transformation: simd_float4x4) -> PNAnimatedCoordinateSpace {
        let decomposed = transformation.decomposed
        return PNAnimatedCoordinateSpace(translation: PNAnyAnimatedValue(PNAnimatedFloat3.static(from: decomposed.translation)),
                                         rotation: PNAnyAnimatedValue(PNAnimatedQuatf.static(from: decomposed.rotation)),
                                         scale: PNAnyAnimatedValue(PNAnimatedFloat3.static(from: decomposed.scale)))
    }
}

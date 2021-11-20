//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension PNAnimatedCoordinateSpace {
    func transformation(at time: TimeInterval, interpolator: PNIInterpolator) -> simd_float4x4 {
        simd_float4x4.compose(translation: interpolator.interpolated(sample: translation.sample(at: time)),
                              rotation: interpolator.interpolated(sample: rotation.sample(at: time)),
                              scale: interpolator.interpolated(sample: scale.sample(at: time)))
    }
    static public var `static`: PNAnimatedCoordinateSpace {
        PNAnimatedCoordinateSpace(translation: PNAnySampleProvider(AnimatedFloat3.defaultTranslation),
                                  rotation: PNAnySampleProvider(AnimatedQuatf.defaultOrientation),
                                  scale: PNAnySampleProvider(AnimatedFloat3.defaultScale))
    }
    static public func `static`(from transformation: simd_float4x4) -> PNAnimatedCoordinateSpace {
        let decomposed = transformation.decomposed
        return PNAnimatedCoordinateSpace(translation: PNAnySampleProvider(AnimatedFloat3.static(from: decomposed.translation)),
                                         rotation: PNAnySampleProvider(AnimatedQuatf.static(from: decomposed.rotation)),
                                         scale: PNAnySampleProvider(AnimatedFloat3.static(from: decomposed.scale)))
    }
}

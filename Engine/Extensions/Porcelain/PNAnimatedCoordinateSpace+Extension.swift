//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension PNAnimatedCoordinateSpace {
    func transformationTRS(at time: TimeInterval, interpolator i: PNInterpolator) -> simd_float4x4 {
        let sampler = PNILoopSampler()
        let t = i.interpolated(sample: sampler.sample(animation: translation, at: time))
        let r = i.interpolated(sample: sampler.sample(animation: rotation, at: time))
        let s = i.interpolated(sample: sampler.sample(animation: scale, at: time))
        return .composeTRS(translation: t, rotation: r, scale: s)
    }
    func transformationRTS(at time: TimeInterval, interpolator i: PNInterpolator) -> simd_float4x4 {
        let sampler = PNILoopSampler()
        let t = i.interpolated(sample: sampler.sample(animation: translation, at: time))
        let r = i.interpolated(sample: sampler.sample(animation: rotation, at: time))
        let s = i.interpolated(sample: sampler.sample(animation: scale, at: time))
        return .composeRTS(translation: t, rotation: r, scale: s)
    }
    static public var `static`: PNAnimatedCoordinateSpace {
        PNAnimatedCoordinateSpace(translation: PNAnimatedFloat3.defaultTranslation,
                                  rotation: PNAnimatedQuatf.defaultOrientation,
                                  scale: PNAnimatedFloat3.defaultScale)
    }
    static public func `static`(from transformation: simd_float4x4) -> PNAnimatedCoordinateSpace {
        let decomposed = transformation.decomposed
        return PNAnimatedCoordinateSpace(translation: PNAnimatedFloat3.static(from: decomposed.translation),
                                         rotation: PNAnimatedQuatf.static(from: decomposed.rotation),
                                         scale: PNAnimatedFloat3.static(from: decomposed.scale))
    }
}

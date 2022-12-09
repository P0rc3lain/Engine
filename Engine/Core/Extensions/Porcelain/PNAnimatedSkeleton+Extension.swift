//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension PNAnimatedSkeleton {
    func localTransformation(at time: TimeInterval, interpolator: PNInterpolator) -> [simd_float4x4] {
        let sampler = PNILoopSampler()
        let translationsPalette = interpolator.interpolated(sample: sampler.sample(animation: translation,
                                                                                   at: time))
        let rotationsPalette = interpolator.interpolated(sample: sampler.sample(animation: rotation,
                                                                                at: time))
        let scalesPalette = interpolator.interpolated(sample: sampler.sample(animation: scale,
                                                                             at: time))
        return translationsPalette.indices.map { index in
            simd_float4x4.composeTRS(translation: translationsPalette[index],
                                     rotation: rotationsPalette[index],
                                     scale: scalesPalette[index])
        }
    }
}

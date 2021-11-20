//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLTransformComponent {
    var decompose: AnimatedCoordinateSpace {
        if !keyTimes.isEmpty {
            let times = keyTimes.map { number in TimeInterval(truncating: number) }
            var translations = [simd_float3]()
            var scales = [simd_float3]()
            var orientations = [simd_quatf]()
            for fraction in times {
                let transform = localTransform?(atTime: fraction) ?? matrix_identity_float4x4
                translations.append(transform.translation)
                orientations.append(simd_quatf(transform))
                scales.append(transform.scale)
            }
            let scaleAnimation = AnimatedFloat3(keyFrames: scales, times: times, maximumTime: maximumTime)
            let translationAnimation = AnimatedFloat3(keyFrames: translations, times: times, maximumTime: maximumTime)
            let orientationAnimation = AnimatedQuatf(keyFrames: orientations, times: times, maximumTime: maximumTime)
            return AnimatedCoordinateSpace(translation: PNAnySampleProvider(translationAnimation),
                                           rotation: PNAnySampleProvider(orientationAnimation),
                                           scale: PNAnySampleProvider(scaleAnimation))
        } else {
            return AnimatedCoordinateSpace.static(from: matrix)
        }
    }
}

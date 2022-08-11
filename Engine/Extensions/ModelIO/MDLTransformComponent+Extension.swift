//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import ModelIO

extension MDLTransformComponent {
    var decomposed: PNAnimatedCoordinateSpace? {
        guard !keyTimes.isEmpty else {
            return nil
        }
        let times = keyTimes.map { number in TimeInterval(truncating: number) }
        var translations = [simd_float3]()
        var scales = [simd_float3]()
        var orientations = [simd_quatf]()
        for fraction in times {
            let transform = localTransform?(atTime: fraction) ?? .identity
            translations.append(transform.translation)
            orientations.append(simd_quatf(transform))
            scales.append(transform.scale)
        }
        let scaleAnimation = PNAnimatedFloat3(keyFrames: scales,
                                              times: times,
                                              maximumTime: maximumTime)
        let translationAnimation = PNAnimatedFloat3(keyFrames: translations,
                                                    times: times,
                                                    maximumTime: maximumTime)
        let orientationAnimation = PNAnimatedQuatf(keyFrames: orientations,
                                                   times: times,
                                                   maximumTime: maximumTime)
        return PNAnimatedCoordinateSpace(translation: PNAnyAnimatedValue(translationAnimation),
                                         rotation: PNAnyAnimatedValue(orientationAnimation),
                                         scale: PNAnyAnimatedValue(scaleAnimation))
    }
}

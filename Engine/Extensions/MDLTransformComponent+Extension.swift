//
//  MDLTransformComponent.swift
//  Binarizer
//
//  Created by Mateusz Stompór on 11/10/2021.
//

import ModelIO

extension MDLTransformComponent {
    var decompose: TransformAnimation {
        if keyTimes.count > 0 {
            let times = keyTimes.map { number in TimeInterval(truncating: number) }
            var translations = [simd_float3]()
            var scales = [simd_float3]()
            var orientations = [simd_quatf]()
            for fraction in times {
                let transform = localTransform!(atTime: fraction)
                translations.append(transform.translation)
                orientations.append(simd_quatf(transform))
                scales.append(transform.scale)
            }
            let scaleAnimation = AnimatedFloat3(keyFrames: scales, times: times, maximumTime: maximumTime)
            let translationAnimation = AnimatedFloat3(keyFrames: translations, times: times, maximumTime: maximumTime)
            let orientationAnimation = AnimatedQuatf(keyFrames: orientations, times: times, maximumTime: maximumTime)
            return TransformAnimation(translation: translationAnimation,
                                      rotation: orientationAnimation,
                                      scale: scaleAnimation)
        } else {
            return TransformAnimation.static(from: matrix)
        }
    }
}

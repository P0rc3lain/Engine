//
//  MDLTransformComponent.swift
//  Binarizer
//
//  Created by Mateusz Stompór on 11/10/2021.
//

import ModelIO

extension MDLTransformComponent {
    var decompose: Transform {
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
        if times.count > 0 {
            let scaleAnimation = AnimatedFloat3(keyFrames: scales, times: times, maximumTime: maximumTime)
            let translationAnimation = AnimatedFloat3(keyFrames: scales, times: times, maximumTime: maximumTime)
            let orientationAnimation = AnimatedQuatf(keyFrames: orientations, times: times, maximumTime: maximumTime)
            let animation = TransformAnimation(scale: scaleAnimation,
                                               translation: translationAnimation,
                                               rotation: orientationAnimation)
            return Transform(coordinateSpace: CoordinateSpace(transformation: matrix),
                             animation: animation)
        } else {
            return Transform(coordinateSpace: CoordinateSpace(transformation: matrix),
                             animation: TransformAnimation())
        }
    }
}

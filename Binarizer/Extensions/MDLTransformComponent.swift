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
        let keyFrames: [CoordinateSpace] = times.map { fraction in
            let transform = localTransform!(atTime: fraction)
            return CoordinateSpace(transformation: transform)
        }
        let animation = TransformAnimation(minimumTime: minimumTime,
                                           maximumTime: maximumTime,
                                           keyTimes: times,
                                           keyFrames: keyFrames)
        return Transform(coordinateSpace: CoordinateSpace(transformation: matrix),
                         animation: animation)
    }
}

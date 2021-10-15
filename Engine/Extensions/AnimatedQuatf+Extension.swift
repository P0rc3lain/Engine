//
//  AnimatedQuatf+Extension.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import simd

extension AnimatedQuatf {
    func interpolated(at time: TimeInterval) -> simd_quatf {
        let result = sample(at: time)
        return simd_slerp(result.current, result.upcoming, result.ratio)
    }
    static var defaultOrientation: AnimatedQuatf {
        return AnimatedQuatf(keyFrames: [simd_quatf(angle: 0, axis: simd_float3(1, 0, 0))], times: [0], maximumTime: 0)
    }
}

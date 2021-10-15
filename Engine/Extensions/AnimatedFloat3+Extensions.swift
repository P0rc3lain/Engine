//
//  AnimatedFloat3+Extensions.swift
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

import simd

extension AnimatedFloat3 {
    func interpolated(at time: TimeInterval) -> simd_float3 {
        let result = sample(at: time)
        return mix(result.current, result.upcoming, t: result.ratio)
    }
    static var defaultScale: AnimatedFloat3 {
        return AnimatedFloat3(keyFrames: [simd_float3(1, 1, 1)], times: [0], maximumTime: 1)
    }
    static var defaultTranslation: AnimatedFloat3 {
        return AnimatedFloat3(keyFrames: [simd_float3(0, 0, 0)], times: [0], maximumTime: 1)
    }
}

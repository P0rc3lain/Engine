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
    static public var defaultScale: AnimatedFloat3 {
        return .static(from: .one)
    }
    static public var defaultTranslation: AnimatedFloat3 {
        return .static(from: .zero)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension AnimatedFloat3 {
    func interpolated(at time: TimeInterval) -> simd_float3 {
        let result = sample(at: time)
        return mix(result.current, result.upcoming, t: result.ratio)
    }
    static public var defaultScale: AnimatedFloat3 {
        .static(from: .one)
    }
    static public var defaultTranslation: AnimatedFloat3 {
        .static(from: .zero)
    }
}

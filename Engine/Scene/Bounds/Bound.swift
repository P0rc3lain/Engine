//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct Bound: Equatable {
    let min: simd_float3
    let max: simd_float3
    func merge(_ bound: Bound) -> Bound {
        Bound(min: [Swift.min(min.x, bound.min.x),
                    Swift.min(min.y, bound.min.y),
                    Swift.min(min.z, bound.min.z)],
              max: [Swift.max(max.x, bound.max.x),
                    Swift.max(max.y, bound.max.y),
                    Swift.max(max.z, bound.max.z)])
    }
    static var zero: Bound {
        Bound(min: [0, 0, 0], max: [0, 0, 0])
    }
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.min == rhs.min && lhs.max == rhs.max
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Represents opposite, extreme points of a given abstract.
/// Shorten version of ``PNBoundingBox``.
public struct PNBound: CustomDebugStringConvertible {
    let min: simd_float3
    let max: simd_float3
    public init(min: simd_float3,
                max: simd_float3) {
        self.min = min
        self.max = max
    }
    public var debugDescription: String {
        "PNBound(min: [\(min.x), \(min.y), \(min.z)], max: [\(max.x), \(max.y), \(max.z)]"
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Represents the opposite, extreme points of an abstract object in 3D space.
/// A shortened version of ``PNBoundingBox`` for simpler cases.
public struct PNBound: CustomDebugStringConvertible {
    /// The minimum (lowest) corner point of the bound in 3D space.
    public let min: simd_float3
    /// The maximum (highest) corner point of the bound in 3D space.
    public let max: simd_float3
    /// Creates a new bound given minimum and maximum 3D points.
    /// - Parameters:
    ///   - min: The minimum (lowest) corner point.
    ///   - max: The maximum (highest) corner point.
    public init(min: simd_float3,
                max: simd_float3) {
        self.min = min
        self.max = max
    }
    /// Returns a string representation of the bound for debugging purposes.
    public var debugDescription: String {
        "PNBound(min: [\(min.x), \(min.y), \(min.z)], max: [\(max.x), \(max.y), \(max.z)]"
    }
}

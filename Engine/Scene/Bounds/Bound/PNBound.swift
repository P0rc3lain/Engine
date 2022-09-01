//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNBound: CustomDebugStringConvertible {
    let min: simd_float3
    let max: simd_float3
    public var debugDescription: String {
        "PNBound(min: [\(min.x), \(min.y), \(min.z)], max: [\(max.x), \(max.y), \(max.z)]"
    }
}

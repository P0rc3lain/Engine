//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Specifies all extreme points of a given abstract.
/// In contrary to ``PNBound`` definitions are explicit.
public struct PNBoundingBox: Equatable {
    let cornersLower: simd_float4x4
    let cornersUpper: simd_float4x4
}

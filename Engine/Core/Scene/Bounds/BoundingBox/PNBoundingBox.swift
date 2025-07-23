//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Specifies all extreme points of a given abstract bounding volume. In contrast to ``PNBound``, definitions are explicit.
public struct PNBoundingBox: Equatable {
    /// The four lower extreme corners of the bounding box, each stored as a column in the matrix.
    public let cornersLower: simd_float4x4
    /// The four upper extreme corners of the bounding box, each stored as a column in the matrix.
    public let cornersUpper: simd_float4x4
}

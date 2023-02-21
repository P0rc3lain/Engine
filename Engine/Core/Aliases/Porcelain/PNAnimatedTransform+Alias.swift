//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Skeleton-based model transformation description.
public typealias PNAnimatedSkeleton = PNAnimatedTransform<[simd_float3], [simd_quatf], [simd_float3]>
/// Rigid body transformation description.
public typealias PNAnimatedCoordinateSpace = PNAnimatedTransform<simd_float3, simd_quatf, simd_float3>

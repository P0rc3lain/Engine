//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public typealias AnimatedSkeleton = AnimatedTransform<[simd_float3], [simd_quatf], [simd_float3]>
public typealias AnimatedCoordinateSpace = AnimatedTransform<simd_float3, simd_quatf, simd_float3>

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public typealias PNAnimatedSkeleton = PNAnimatedTransform<[simd_float3], [simd_quatf], [simd_float3]>
public typealias PNAnimatedCoordinateSpace = PNAnimatedTransform<simd_float3, simd_quatf, simd_float3>

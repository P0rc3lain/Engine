//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

/// A vector representing three color components.
/// Stored as red, green and blue channels.
/// Normalized, values are ranging from 0.0 to 1.0.
public typealias PNColorRGB = simd_float3
/// A vector representing three color components.
/// Stored as blue, red and green channels.
/// Normalized, values are ranging from 0.0 to 1.0.
public typealias PNColorBGR = simd_float3
/// A vector representing three color components.
/// Normalized, values are ranging from 0.0 to 1.0.
public typealias PNColor3 = simd_float3
/// Vector representing point in three-dimensional space.
public typealias PNPoint3D = simd_float3
/// Vector representing direction in three-dimensional space.
public typealias PNDirection3D = simd_float3
/// Vector representing direction in three-dimensional space.
/// Normalized, values are raning from 0.0 to 1.0.
public typealias PNDirection3DN = simd_float3
/// Three-dimensional vector
public typealias PNFloat3 = simd_float3

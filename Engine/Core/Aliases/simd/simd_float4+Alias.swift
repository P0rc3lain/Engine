//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

/// A vector representing four color components.
/// Normalized, values are ranging from 0.0 to 1.0.
public typealias PNColor4 = simd_float4
/// A vector representing four color components.
/// Stored as red, green, blue and alpha channels.
/// Normalized, values are ranging from 0.0 to 1.0.
public typealias PNColorRGBA = simd_float4
/// A vector representing four color components.
/// Stored as blue, red, green and alpha channels.
/// Normalized, values are ranging from 0.0 to 1.0.
public typealias PNColorBGRA = simd_float4
/// Four-dimensional vector
public typealias PNFloat4 = simd_float4

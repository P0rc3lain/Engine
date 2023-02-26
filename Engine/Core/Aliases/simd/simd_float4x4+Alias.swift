//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// 4x4 transform matrix converting from bone to model coordinate space.
public typealias PNB2MTransform = simd_float4x4
/// 4x4 transform matrix converting from model to bone coordinate space.
public typealias PNM2BTransform = simd_float4x4
/// 4x4 matrix  converting from model to world coordinate space.
public typealias PNM2WTransform = simd_float4x4
/// A general transform matrix 4x4.
public typealias PNTransform = simd_float4x4
/// 4x4 matrix representing local transform in bone coordinate space.
public typealias PNBLTransform = simd_float4x4
/// 4x4 matrix representing local transform in unspecified coordinate space.
public typealias PNLTransform = simd_float4x4
/// 4x4 matrix.
public typealias PNFloat4x4 = simd_float4x4

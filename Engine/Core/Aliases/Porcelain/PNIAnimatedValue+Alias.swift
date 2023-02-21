//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// A sequence of keyframes that uses three-dimensional vector as its backing value.
public typealias PNAnimatedFloat3 = PNKeyframeAnimation<simd_float3>
/// A sequence of keyframes that uses quaternion vector as its backing value.
public typealias PNAnimatedQuatf = PNKeyframeAnimation<simd_quatf>
/// A sequence of keyframes that uses array of three-dimensional vectors as value.
/// Used for skeletal animations - bone manipulation.
public typealias PNAnimatedFloat3Array = PNKeyframeAnimation<[simd_float3]>
/// A sequence of keyframes that uses array of three-dimensional quaternions as value.
/// Used for skeletal animations - bone manipulation.
public typealias PNAnimatedQuatfArray = PNKeyframeAnimation<[simd_quatf]>

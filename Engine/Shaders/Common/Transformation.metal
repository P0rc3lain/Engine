//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include "Transformation.h"

using namespace metal;

float3x3 extractRotation(float4x4 transformation) {
    return float3x3(transformation.columns[0].xyz,
                    transformation.columns[1].xyz,
                    transformation.columns[2].xyz);
}

metal::float3x3 normalizeEachColumn(metal::float3x3 transformation) {
    return float3x3(normalize(transformation.columns[0]),
                    normalize(transformation.columns[1]),
                    normalize(transformation.columns[2]));
}

float4 extractPosition(float4x4 transformation) {
    return transformation.columns[3];
}

float4x4 scaleMatrix(float sx, float sy, float sz) {
    return simd_float4x4(
        simd_float4(sx,  0,  0, 0),
        simd_float4( 0, sy,  0, 0),
        simd_float4( 0,  0, sz, 0),
        simd_float4( 0,  0,  0, 1)
    );
}

float3x3 scaleMatrix3x3(float sx, float sy, float sz) {
    return simd_float3x3(
        simd_float3(sx,  0,  0),
        simd_float3( 0, sy,  0),
        simd_float3( 0,  0, sz)
    );
}

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

float4 extractPosition(float4x4 transformation) {
    return transformation.columns[3];
}

simd::float4x4 perspectiveProjection(float fovYRadians,
                                     float aspect,
                                     float nearZ,
                                     float farZ)
{
    float ys = 1.0f / tan(fovYRadians * 0.5f);
    float xs = ys / aspect;
    float zs = farZ / (farZ - nearZ);
    
    return simd::float4x4{
        simd::float4(xs,  0,   0,   0),
        simd::float4( 0, ys,   0,   0),
        simd::float4( 0,  0,  zs,   1),
        simd::float4( 0,  0, -zs * nearZ, 0)
    };
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

struct DirectionalLight {
    simd_float3 color;
    float intensity;
    simd_float4x4 rotationMatrix;
    simd_float4x4 rotationMatrixInverse;
    simd_float4x4 projectionMatrix;
    simd_float4x4 projectionMatrixInverse;
};

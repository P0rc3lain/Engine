//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

struct OmniLight {
    simd_float3 color;
    float intensity;
    float influenceRadius;
    int32_t idx;
    simd_float4x4 projectionMatrix;
    simd_float4x4 projectionMatrixInverse;
    uint8_t castsShadows;
    float nearPlane;
    float farPlane;
};

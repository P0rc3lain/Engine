//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

struct SpotLight {
    simd_float3 color;
    float intensity;
    float influenceRadius;
    simd_float4x4 projectionMatrix;
    simd_float4x4 projectionMatrixInverse;
    float coneAngle;
    float innerConeAngle;
    float outerConeAngle;
    int idx;
    uint8_t castsShadows;
};

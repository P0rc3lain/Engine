//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef SPOT_LIGHT_H
#define SPOT_LIGHT_H

struct SpotLight {
    simd_float3 color;
    float intensity;
    simd_float4x4 projectionMatrix;
    simd_float4x4 projectionMatrixInverse;
    float coneAngle;
    int idx;
};

#endif /* SPOT_LIGHT_H */

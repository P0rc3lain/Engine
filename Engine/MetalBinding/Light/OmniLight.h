//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef OMNILIGHT_H
#define OMNILIGHT_H

struct OmniLight {
    simd_float3 color;
    float intensity;
    int idx;
    simd_float4x4 projectionMatrix;
    simd_float4x4 projectionMatrixInverse;
};

#endif /* OMNILIGHT_H */

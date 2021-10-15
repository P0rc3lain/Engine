//
//  OmniLight.h
//  Engine
//
//  Created by Mateusz Stompór on 15/10/2021.
//

#ifndef OMNILIGHT_H
#define OMNILIGHT_H

struct OmniLightUniforms {
    simd_float4x4 projectionMatrix;
    simd_float4x4 viewMatrix;
    simd_float4x4 viewMatrixInverse;
};

struct OmniLight {
    simd_float3 color;
    float intensity;
    int idx;
};

#endif /* OMNILIGHT_H */

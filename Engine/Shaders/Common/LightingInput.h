//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef LIGHTING_INPUT_H
#define LIGHTING_INPUT_H

#include <simd/simd.h>

struct LightingInput {
    float3 fragmentPosition;
    float reflectance;
    float3 n;
    float metallicFactor;
    float3 baseColor;
    float roughnessFactor;
    static LightingInput fromTextures(metal::texture2d<float> ar,
                                      metal::texture2d<float> nm,
                                      metal::texture2d<float> pr,
                                      metal::sampler sampler,
                                      float2 textureCoordinates) {
        float4 arV = ar.sample(sampler, textureCoordinates);
        float4 nmV = nm.sample(sampler, textureCoordinates);
        float4 prV = pr.sample(sampler, textureCoordinates);
        return LightingInput{
            prV.xyz,
            prV.w,
            nmV.xyz,
            nmV.w,
            arV.xyz,
            arV.w
        };
    }
};

#endif /* LIGHTING_INPUT_H */

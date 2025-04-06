//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#include "Grain.h"

#include "../Common/Math.h"
#include "../Common/Layer.h"

using namespace metal;

#define BLEND_MODE 1
#define SPEED 1.2f
#define INTENSITY 0.04f
#define MEAN 0.0f
#define VARIANCE 0.5f

float4 grain(float time, float2 texcoord, float3 inputColor) {
    float t = time * float(SPEED);
    float seed = dot(texcoord, float2(12.9898, 78.233));
    float noise = fract(sin(seed) * 43758.5453 + t);
    noise = gaussian(noise, float(MEAN), float(VARIANCE) * float(VARIANCE));
    float3 grain = float3(noise) * (1.0 - inputColor.xyz);
    #if BLEND_MODE == 0
    return float4(grain * INTENSITY + vignetteColor, 1);
    #elif BLEND_MODE == 1
    return float4(screen(inputColor.xyz, grain, INTENSITY), 1);
    #elif BLEND_MODE == 2
    return float4(overlay(inputColor.xyz, grain, INTENSITY), 1);
    #elif BLEND_MODE == 3
    return float4(softLight(inputColor.xyz, grain, INTENSITY), 1);
    #elif BLEND_MODE == 4
    return float4(max(inputColor.xyz, grain * INTENSITY), 1);
    #endif
}

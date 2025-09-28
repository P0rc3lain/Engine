//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#include "Grain.h"

#include "../Common/Math.h"
#include "../Common/Layer.h"

using namespace metal;

#define BLEND_MODE 1
#define SPEED 1.2h
#define INTENSITY 0.04h
#define MEAN 0.0h
#define VARIANCE 0.5h

half3 grain(float time, half2 texcoord, half3 inputColor) {
    float t = time * float(SPEED);
    float seed = dot(float2(texcoord), float2(12.9898, 78.233));
    float noise = fract(sin(seed) * 43758.5453 + t);
    noise = gaussian(noise, float(MEAN), float(VARIANCE) * float(VARIANCE));
    half3 grain = half3(noise) * (1.0h - inputColor.xyz);
    #if BLEND_MODE == 0
    return grain * INTENSITY + vignetteColor;
    #elif BLEND_MODE == 1
    return screen(inputColor.xyz, grain, INTENSITY);
    #elif BLEND_MODE == 2
    return overlay(inputColor.xyz, grain, INTENSITY);
    #elif BLEND_MODE == 3
    return softLight(inputColor.xyz, grain, INTENSITY);
    #elif BLEND_MODE == 4
    return max(inputColor.xyz, grain * INTENSITY);
    #endif
}

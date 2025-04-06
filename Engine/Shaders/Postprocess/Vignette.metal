//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#include "Vignette.h"

using namespace metal;

float4 vignette(float4 fragmentColor, float4 vignetteColor, float2 position, float fromRadius, float toRadius) {
    float radius = length(float2(0.5, 0.5) - position) * 2;
    float ratio = saturate(radius - fromRadius) / (toRadius - fromRadius);
    return mix(fragmentColor, vignetteColor, ratio);
}

//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#include "Vignette.h"

using namespace metal;

half4 vignette(half4 fragmentColor,
               half4 vignetteColor,
               float2 position,
               half fromRadius,
               half toRadius) {
    half radius = length(float2(0.5f, 0.5f) - position) * 2.0h;
    half ratio = saturate(radius - fromRadius) / (toRadius - fromRadius);
    return mix(fragmentColor, vignetteColor, ratio);
}

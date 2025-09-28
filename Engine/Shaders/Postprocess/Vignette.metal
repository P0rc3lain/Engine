//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#include "Vignette.h"

using namespace metal;

half4 vignette(half4 fragmentColor,
               half4 vignetteColor,
               half2 position,
               half fromRadius,
               half toRadius) {
    half radius = length(half2(0.5h, 0.5h) - position) * 2.0h;
    half ratio = saturate(radius - fromRadius) / (toRadius - fromRadius);
    return mix(fragmentColor, vignetteColor, ratio);
}

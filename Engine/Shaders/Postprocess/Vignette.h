//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <metal_stdlib>

metal::float4 vignette(metal::float4 fragmentColor,
                       metal::float4 vignetteColor,
                       metal::float2 position,
                       float fromRadius,
                       float toRadius);

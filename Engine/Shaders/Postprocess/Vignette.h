//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <metal_stdlib>

metal::half4 vignette(metal::half4 fragmentColor,
                      metal::half4 vignetteColor,
                      metal::float2 position,
                      half fromRadius,
                      half toRadius);

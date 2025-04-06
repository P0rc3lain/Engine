//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <metal_stdlib>

metal::float4 grain(float time,
                    metal::float2 texcoord,
                    metal::float3 inputColor);

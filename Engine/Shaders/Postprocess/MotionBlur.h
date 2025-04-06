//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <metal_stdlib>

metal::float4 motionBlur(metal::texture2d<float> inputTexture,
                         metal::texture2d<float> velocityTexture,
                         metal::uint2 gid,
                         float scale,
                         unsigned int samples);

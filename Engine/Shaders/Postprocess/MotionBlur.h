//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <metal_stdlib>

metal::half4 motionBlur(metal::texture2d<half> inputTexture,
                        metal::texture2d<half> velocityTexture,
                        metal::uint2 gid,
                        half scale,
                        unsigned int samples);

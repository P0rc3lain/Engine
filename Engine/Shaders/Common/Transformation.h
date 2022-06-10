//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <simd/simd.h>

metal::float3x3 extract_rotation(metal::float4x4 transformation);
metal::float4 extract_position(metal::float4x4 transformation);

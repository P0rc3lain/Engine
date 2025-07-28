//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <simd/simd.h>

metal::float3x3 extractRotation(thread const metal::float4x4 transformation);
metal::float4 extractPosition(thread const metal::float4x4 transformation);

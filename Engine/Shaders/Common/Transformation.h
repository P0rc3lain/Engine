//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <simd/simd.h>

metal::float3x3 extractRotation(metal::float4x4 transformation);
metal::float4 extractPosition(metal::float4x4 transformation);
metal::float4x4 scaleMatrix(float sx, float sy, float sz);
metal::float3x3 scaleMatrix3x3(float sx, float sy, float sz);
metal::float3x3 normalizeEachColumn(metal::float3x3 transformation);

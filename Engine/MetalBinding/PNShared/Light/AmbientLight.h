//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <simd/simd.h>

struct AmbientLight {
    simd_float3 color;
    float diameter;
    float intensity;
    int idx;
};

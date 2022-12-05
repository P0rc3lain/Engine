//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

struct AmbientLight {
    float diameter;
    simd_float3 color;
    float intensity;
    int idx;
};

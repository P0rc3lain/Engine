//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include "Math.h"

#include <simd/simd.h>
#include <metal_stdlib>

using namespace metal;

float gaussian(float z, float u, float o) {
    return (1.0 / (o * sqrt(2.0 * M_PI_F))) * exp(-(((z - u) * (z - u)) / (2.0 * (o * o))));
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#pragma once

#include <simd/simd.h>

struct ModelUniforms {
    simd_float4x4 modelMatrix;
    simd_float4x4 modelMatrixInverse;
};

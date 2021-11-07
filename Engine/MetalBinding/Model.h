//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef MODEL_H
#define MODEL_H

#include <simd/simd.h>

struct ModelUniforms {
    simd_float4x4 modelMatrix;
    simd_float4x4 modelMatrixInverse;
};

#endif /* MODEL_H */

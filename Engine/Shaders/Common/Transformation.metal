//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include "Transformation.h"

using namespace metal;

matrix_float4x4 scale(metal::float3 scale) {
    return matrix_float4x4(scale.x,     0,          0,          0,
                           0,           scale.y,    0,          0,
                           0,           0,          scale.z,    0,
                           0,           0,          0,          1);
}

matrix_float4x4 translation(metal::float3 translation) {
    return matrix_float4x4(1,                       0,                      0,                  0,
                           0,                       1,                      0,                  0,
                           0,                       0,                      1,                  0,
                           translation.x,           translation.y,          translation.z,      1);
}

matrix_float3x3 extract_rotation(matrix_float4x4 transformation) {
    return matrix_float3x3(transformation.columns[0].xyz, transformation.columns[1].xyz, transformation.columns[2].xyz);
}

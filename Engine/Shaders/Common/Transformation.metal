//
//  Transformation.metal
//  Engine
//
//  Created by Mateusz Stompór on 14/11/2020.
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


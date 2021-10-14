//
//  Transformation.h
//  Engine
//
//  Created by Mateusz Stompór on 07/11/2020.
//

#ifndef TRANSFORMATION_H
#define TRANSFORMATION_H

#include <simd/simd.h>

matrix_float4x4 scale(metal::float3 scale);
matrix_float4x4 translation(metal::float3 translation);

#endif

//
//  Types.h
//  Demo
//
//  Created by Mateusz Stompór on 09/11/2020.
//

#ifndef TYPES_H
#define TYPES_H

#include <simd/simd.h>

#include "Compatibility.h"

struct VertexP2T2 {
    simd_float2 position;
    simd_float2 uv_coordinate;
};

struct VertexP3N3 {
    simd_float3 position    metal_only([[attribute(0)]]);
    simd_float3 normal      metal_only([[attribute(1)]]);
};

#endif /* TYPES_H */

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

struct Vertex {
    simd_float3 position    metal_only([[attribute(0)]]);
    simd_float3 normal      metal_only([[attribute(1)]]);
    simd_float3 tangent     metal_only([[attribute(2)]]);
    simd_float2 textureUV   metal_only([[attribute(3)]]);
};

struct CameraUniforms {
    simd_float4x4 projectionMatrix;
    simd_float4x4 viewMatrix;
    simd_float4x4 viewMatrixInverse;
};

struct ModelUniforms {
    simd_float4x4 modelMatrix;
    simd_float4x4 modelMatrixInverse;
    simd_float4x4 modelMatrixInverse2;
    simd_float4x4 modelMatrixInverse3;
};

#endif /* TYPES_H */

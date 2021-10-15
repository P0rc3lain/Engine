//
//  Vertex.h
//  Types
//
//  Created by Mateusz Stompór on 14/10/2021.
//

#ifndef VERTEX_H
#define VERTEX_H

#include <simd/simd.h>

#include "Compatibility.h"

enum VertexAttribute {
    kVertexAttributePositionIndex = 0,
    kVertexAttributeNormalIndex,
    kVertexAttributeTangentIndex,
    kVertexAttributeTextureUV
};

struct Vertex {
    simd_float3 position    metal_only([[attribute(kVertexAttributePositionIndex)]]);
    simd_float3 normal      metal_only([[attribute(kVertexAttributeNormalIndex)]]);
    simd_float3 tangent     metal_only([[attribute(kVertexAttributeTangentIndex)]]);
    simd_float2 textureUV   metal_only([[attribute(kVertexAttributeTextureUV)]]);
};

struct CameraUniforms {
    simd_float4x4 projectionMatrix;
    simd_float4x4 viewMatrix;
    simd_float4x4 viewMatrixInverse;
};

struct OmniLightUniforms {
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

#endif /* VERTEX_H */

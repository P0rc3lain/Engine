//
//  PBR.metal
//  Porcelain
//
//  Created by Mateusz Stompór on 05/11/2020.
//

#include <metal_stdlib>
#include <simd/simd.h>

#include "Math.h"
#include "../SharedTypes/Types.h"

using namespace metal;
    
struct RasterizerData {
    float4 clipSpacePosition [[position]];
    float3 normal;
    float2 uv;
};

struct Uniforms {
    matrix_float4x4 projection_matrix;
    matrix_float4x4 rotation;
    simd_float3 translation;
    simd_float3 scale;
};

vertex RasterizerData vertexFunction(VertexP3N3T2 in [[stage_in]],
                                     constant Uniforms * uniforms [[buffer(1)]]) {
    RasterizerData out;
    float4 position = float4(in.position, 1);
    float4 clipSpacePosition = uniforms->projection_matrix * uniforms->rotation * translation(uniforms->translation) * scale(uniforms->scale) * position;
    out.clipSpacePosition = clipSpacePosition;
    out.normal = in.normal.xyz;
    out.uv = in.textureUV;
    return out;
}

fragment float4 fragmentFunction(RasterizerData in [[stage_in]]) {
    return float4(in.uv, 1, 1);
}

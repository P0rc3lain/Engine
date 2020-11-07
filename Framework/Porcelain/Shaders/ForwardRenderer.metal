//
//  PBR.metal
//  Porcelain
//
//  Created by Mateusz Stompór on 05/11/2020.
//

#include "Math.h"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;
    
struct Vertex {
    simd_float3 position [[attribute(0)]];
    simd_float3 normal [[attribute(1)]];
};

struct RasterizerData {
    float4 clipSpacePosition [[position]];
    float3 normal;
};

struct Uniforms {
    matrix_float4x4 projection_matrix;
    matrix_float4x4 rotation;
    simd_float3 translation;
    simd_float3 scale;
};

vertex RasterizerData vertexFunction(Vertex in [[stage_in]],
                                     constant Uniforms * uniforms [[buffer(1)]]) {
    RasterizerData out;
    float4 position = float4(in.position, 1);
    float4 clipSpacePosition = uniforms->projection_matrix * uniforms->rotation * translation(uniforms->translation) * scale(uniforms->scale) * position;
    out.clipSpacePosition = clipSpacePosition;
    out.normal = in.normal.xyz;
    return out;
}

fragment float4 fragmentFunction(RasterizerData in [[stage_in]]) {
    return float4(in.normal, 1);
}

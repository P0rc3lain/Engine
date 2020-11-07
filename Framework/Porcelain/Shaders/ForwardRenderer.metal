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
    vector_float3 position;
    vector_float3 normal;
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
    
    
    

vertex RasterizerData vertexFunction(uint vertexID [[vertex_id]],
                                     constant Vertex *vertices [[buffer(0)]],
                                     constant Uniforms * uniforms [[buffer(1)]]) {
    RasterizerData out;
    float4 pos = float4(vertices[vertexID].position, 1) + float4(0, 0, -1000, 0);
    out.clipSpacePosition = uniforms->projection_matrix * translation(uniforms->translation) * uniforms->rotation * scale(uniforms->scale) * pos;
    out.normal = vertices[vertexID].normal;
    return out;
}

fragment float4 fragmentFunction(RasterizerData in [[stage_in]]) {
    return float4(in.normal, 1);
}

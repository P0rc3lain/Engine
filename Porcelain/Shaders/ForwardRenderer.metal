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
    float3 tangentSpacePosition;
    float3 lightPosition;
    float2 uv;
};

struct Uniforms {
    matrix_float4x4 projection_matrix;
    matrix_float4x4 rotation;
    simd_float3 translation;
    simd_float3 scale;
};

vertex RasterizerData vertexFunction(VertexP3N3T3Tx2        in          [[stage_in]],
                                     constant Uniforms &    uniforms    [[buffer(1)]]) {
    RasterizerData out;
    simd_float4x4 worldToView = uniforms.rotation * translation(uniforms.translation) * scale(uniforms.scale);
    simd_float3x3 tbn(normalize(in.tangent), -normalize(cross(in.tangent, in.normal)), normalize(in.normal));
    tbn = transpose(tbn);
    float4 viewPosition = worldToView * float4(in.position, 1);
    float4 clipSpacePosition = uniforms.projection_matrix * viewPosition;
    out.clipSpacePosition = clipSpacePosition;
    out.tangentSpacePosition = tbn * in.position;
    out.uv = in.textureUV;
    simd_float3 lightPosition(0, 5, 5);
    out.lightPosition = tbn * lightPosition;
    return out;
}

fragment float4 fragmentFunction(RasterizerData     in          [[stage_in]],
                                 texture2d<float>   albedo      [[texture(0)]],
                                 texture2d<float>   roughness   [[texture(1)]],
                                 texture2d<float>   emission    [[texture(2)]],
                                 texture2d<float>   normals     [[texture(3)]],
                                 texture2d<float>   metallic    [[texture(4)]]) {
    constexpr sampler textureSampler;
    float3 n = normals.sample(textureSampler, in.uv).xyz;
    n = normalize(n * 2.0 - 1.0);
    float3 oTl = normalize(in.lightPosition - in.tangentSpacePosition);
    float factor = dot(n, oTl);
    return albedo.sample(textureSampler, in.uv) * factor;
}

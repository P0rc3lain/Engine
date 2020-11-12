//
//  PBR.metal
//  Porcelain
//
//  Created by Mateusz Stompór on 05/11/2020.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "PBR.h"
#include "Math.h"
#include "../SharedTypes/Types.h"

using namespace metal;
 
struct RasterizerData {
    float4 clipSpacePosition [[position]];
    float3 tangentSpacePosition;
    float3 tangentCameraPosition;
    float3 tangentLightPosition;
    float2 uv;
};

struct OmniLight {
    simd_float3 color;
    float intensity;
    simd_float3 position;
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
    simd_float4 cameraWorldPosition = worldToView * simd_float4(0, 0, 0, 1);
    out.tangentCameraPosition = tbn * cameraWorldPosition.xyz;
    float4 viewPosition = worldToView * float4(in.position, 1);
    float4 clipSpacePosition = uniforms.projection_matrix * viewPosition;
    out.clipSpacePosition = clipSpacePosition;
    out.tangentSpacePosition = tbn * in.position;
    out.tangentLightPosition = tbn * float3(-3, 10, -4);
    out.uv = in.textureUV;
    return out;
}

fragment float4 fragmentFunction(RasterizerData     in          [[stage_in]],
                                 texture2d<float>   albedo      [[texture(0)]],
                                 texture2d<float>   roughness   [[texture(1)]],
                                 texture2d<float>   emission    [[texture(2)]],
                                 texture2d<float>   normals     [[texture(3)]],
                                 texture2d<float>   metallic    [[texture(4)]],
                                 constant OmniLight *    lights    [[buffer(10)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::nearest);
    
    float3 normal = normalize(normals.sample(textureSampler, in.uv).xyz * 2.0 - 1.0);
    float3 eye = normalize(in.tangentCameraPosition - in.tangentSpacePosition);
    float3 l = normalize(in.tangentLightPosition - in.tangentSpacePosition);
    float3 halfway = normalize(l + eye);
    // diffuse
    float3 baseColor = albedo.sample(textureSampler, in.uv).xyz;
    float metallicFactor = metallic.sample(textureSampler, in.uv).x;
    float roughnessFactor = roughness.sample(textureSampler, in.uv).x;


    float3 ambient = 0.01;
    float3 diffuse = 1 / M_PI_F;
    float3 specular = brdf(normal, eye, halfway, l, roughnessFactor, metallicFactor);
    float3 color = ambient * baseColor + diffuse * baseColor + specular * baseColor;
    return float4(color * dot(normal, l), 1);
}

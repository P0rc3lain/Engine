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
    float3 t;
    float3 b;
    float3 n;
    float2 uv;
};

struct OmniLight {
    simd_float3 color;
    float intensity;
    simd_float3 position;
};

struct Uniforms {
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 viewMatrixInverse;
    int32_t omniLightsCount;
};

vertex RasterizerData vertexFunction(VertexP3N3T3Tx2        in          [[stage_in]],
                                     constant Uniforms &    uniforms    [[buffer(1)]]) {
    RasterizerData out;
    out.t = normalize(in.tangent);
    out.b = normalize(cross(in.tangent, in.normal));
    out.n = normalize(in.normal);
    simd_float3x3 TBN(out.t, out.b, out.n);
    simd_float3x3 inversedTBN(transpose(TBN));
    simd_float4 cameraWorldPosition = uniforms.viewMatrixInverse * simd_float4(0, 0, 0, 1);
    out.tangentCameraPosition = inversedTBN * cameraWorldPosition.xyz;
    float4 viewPosition = uniforms.viewMatrix * float4(in.position, 1);
    out.clipSpacePosition = uniforms.projectionMatrix * viewPosition;;
    out.tangentSpacePosition = inversedTBN * in.position;
    out.uv = in.textureUV;
    return out;
}

fragment float4 fragmentFunction(RasterizerData         in          [[stage_in]],
                                 texture2d<float>       albedo      [[texture(0)]],
                                 texture2d<float>       roughness   [[texture(1)]],
                                 texture2d<float>       emission    [[texture(2)]],
                                 texture2d<float>       normals     [[texture(3)]],
                                 texture2d<float>       metallic    [[texture(4)]],
                                 constant Uniforms &    uniforms    [[buffer(1)]],
                                 constant OmniLight *   omniLights  [[buffer(10)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::nearest);
    simd_float3x3 TBN(in.t, in.b, in.n);
    simd_float3x3 inversedTBN(transpose(TBN));
    float3 normal = normalize(normals.sample(textureSampler, in.uv).xyz * 2.0 - 1.0);
    float3 eye = normalize(in.tangentCameraPosition - in.tangentSpacePosition);
    float3 baseColor = albedo.sample(textureSampler, in.uv).xyz;
    float metallicFactor = metallic.sample(textureSampler, in.uv).x;
    float roughnessFactor = roughness.sample(textureSampler, in.uv).x;
    float3 outputColor(0, 0, 0);
    for (int i=0; i<uniforms.omniLightsCount; ++i) {
        float4 lightWorldPosition = float4(omniLights[i].position, 1);
        float3 lightTangentPosition = inversedTBN * lightWorldPosition.xyz;
        float3 l = normalize(lightTangentPosition - in.tangentSpacePosition);
        float3 halfway = normalize(l + eye);
        float3 diffuse = 1 / M_PI_F;
        float3 specular = brdf(normal, eye, halfway, l, roughnessFactor, metallicFactor);
        float3 color =  baseColor * diffuse + baseColor * specular;
        outputColor += color * omniLights[i].color * dot(normal, l) * omniLights[i].intensity;
    }
    float ambient = 0.1;
    outputColor += baseColor * ambient;
    return float4(outputColor, 1);
}

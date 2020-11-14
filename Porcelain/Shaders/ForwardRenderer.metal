//
//  PBR.metal
//  Porcelain
//
//  Created by Mateusz Stompór on 05/11/2020.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "PBR.h"
#include "Transformation.h"
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

vertex RasterizerData vertexFunction(Vertex                     in              [[stage_in]],
                                     constant FRDrawUniforms &  drawUniforms    [[buffer(1)]],
                                     constant FRModelUniforms & modelUniforms   [[buffer(2)]]) {
    RasterizerData out;
    out.t = normalize(in.tangent);
    out.b = normalize(cross(in.tangent, in.normal));
    out.n = normalize(in.normal);
    simd_float3x3 TBN(out.t, out.b, out.n);
    simd_float3x3 inversedTBN(transpose(TBN));
    simd_float4 cameraWorldPosition = drawUniforms.viewMatrixInverse * simd_float4(0, 0, 0, 1);
    out.tangentCameraPosition = inversedTBN * (modelUniforms.modelMatrixInverse * cameraWorldPosition).xyz;
    float4 viewPosition = drawUniforms.viewMatrix * modelUniforms.modelMatrix * float4(in.position, 1);
    out.clipSpacePosition = drawUniforms.projectionMatrix * viewPosition;
    out.tangentSpacePosition = inversedTBN * in.position;
    out.uv = in.textureUV;
    return out;
}

fragment float4 fragmentFunction(RasterizerData             in              [[stage_in]],
                                 texture2d<float>           albedo          [[texture(0)]],
                                 texture2d<float>           roughness       [[texture(1)]],
                                 texture2d<float>           normals         [[texture(2)]],
                                 texture2d<float>           metallic        [[texture(3)]],
                                 constant FRDrawUniforms &  drawUniforms    [[buffer(1)]],
                                 constant FRModelUniforms & modelUniforms   [[buffer(2)]],
                                 constant OmniLight *       omniLights      [[buffer(3)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::nearest);
    simd_float3x3 TBN(in.t, in.b, in.n);
    simd_float3x3 inversedTBN(transpose(TBN));
    float3 normal = normalize(normals.sample(textureSampler, in.uv).xyz * 2.0 - 1.0);
    float3 eye = normalize(in.tangentCameraPosition - in.tangentSpacePosition);
    float3 baseColor = albedo.sample(textureSampler, in.uv).xyz;
    float metallicFactor = metallic.sample(textureSampler, in.uv).x;
    float roughnessFactor = roughness.sample(textureSampler, in.uv).x;
    float3 outputColor(0, 0, 0);
    for (int i=0; i<drawUniforms.omniLightsCount; ++i) {
        float4 lightWorldPosition = float4(omniLights[i].position, 1);
        float3 lightTangentPosition = inversedTBN * lightWorldPosition.xyz;
        float3 l = normalize(lightTangentPosition - in.tangentSpacePosition);
        float3 halfway = normalize(l + eye);
        // dielectricsCommonReflectance
        float reflectance = 0.04;
        float3 f0 = 0.16 * reflectance * reflectance * (1 - metallicFactor) + metallicFactor * baseColor;
        float3 specular = cookTorrance(normal, eye, halfway, l, roughnessFactor, f0);
        float3 diffuseColor = (1 - metallicFactor) * baseColor;
        float3 color =  diffuseColor / M_PI_F + specular;
        outputColor += color * omniLights[i].color * dot(normal, l) * omniLights[i].intensity;
    }
    float ambient = 0.1;
    outputColor += baseColor * ambient;
    return float4(outputColor, 1);
}

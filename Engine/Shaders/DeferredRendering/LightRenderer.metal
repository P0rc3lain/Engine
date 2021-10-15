//
//  LightRenderer.metal
//  Engine
//
//  Created by Mateusz Stompór on 14/11/2020.
//

#include <metal_stdlib>

#include <simd/simd.h>
#include "../Common/PBR.h"
#include "../../SharedTypes/Types.h"

using namespace metal;

struct OmniLight {
    simd_float3 color;
    float intensity;
    int idx;
};

struct TexturePipelineRasterizerData {
    float4 position [[position]];
    float2 texcoord;
    uint instanceId [[flat]];
};

vertex TexturePipelineRasterizerData vertexDeferredLight(Vertex in          [[stage_in]],
                                                         uint   instanceId  [[instance_id]]) {
    TexturePipelineRasterizerData out;
    out.position = float4(in.position, 1);
    out.texcoord = in.textureUV;
    out.instanceId = instanceId;
    return out;
}

fragment float4 fragmentDeferredLight(TexturePipelineRasterizerData in              [[stage_in]],
                                      texture2d<float>              ar              [[texture(0)]],
                                      texture2d<float>              nm              [[texture(1)]],
                                      texture2d<float>              pr              [[texture(2)]],
                                      constant CameraUniforms &     camera          [[buffer(1)]],
                                      constant OmniLight *          omniLights      [[buffer(3)]],
                                      constant ModelUniforms *      lightUniforms   [[buffer(4)]]) {
    constexpr sampler textureSampler(mag_filter::nearest, min_filter::nearest);
    float4 arV = ar.sample(textureSampler, in.texcoord);
    float4 nmV = nm.sample(textureSampler, in.texcoord);
    float4 prV = pr.sample(textureSampler, in.texcoord);
    
    float3 worldPosition = prV.xyz;
    float reflectance = prV.w;
    
    float3 n = nmV.xyz;
    float metallicFactor = nmV.w;
    
    float3 baseColor = arV.xyz;
    float roughnessFactor = arV.w;

    float3 cameraWorld = (camera.viewMatrixInverse * float4(0, 0, 0, 1)).xyz;
    float3 eye = normalize(cameraWorld - worldPosition);
    
    float3 outputColor(0, 0, 0);
    int id = omniLights[in.instanceId].idx;
    float4 lightPosition = lightUniforms[id].modelMatrix * float4(0, 0, 0, 1);
    float3 l = normalize(lightPosition.xyz - worldPosition);
    float3 halfway = normalize(l + eye);
    float3 f0 = 0.16 * reflectance * reflectance * (1 - metallicFactor) + metallicFactor * baseColor;
    float3 specular = cookTorrance(n, eye, halfway, l, roughnessFactor, f0);
    float3 diffuseColor = (1 - metallicFactor) * baseColor;
    float3 color =  diffuseColor / M_PI_F + specular;
    outputColor += color * omniLights[in.instanceId].color * dot(n, l) * omniLights[in.instanceId].intensity;
    float ambient = 0.1;
    outputColor += baseColor * ambient;
    return float4(outputColor, 1);
}

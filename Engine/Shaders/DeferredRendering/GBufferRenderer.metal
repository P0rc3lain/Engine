//
//  GBufferRenderer.metal
//  Engine
//
//  Created by Mateusz Stompór on 14/11/2020.
//

#include <metal_stdlib>

#include "../Common/PBR.h"
#include "../../MetalBinding/Vertex.h"

using namespace metal;

struct RasterizerData {
    float4 clipSpacePosition [[position]];
    float3 worldSpacePosition;
    float3 t;
    float3 b;
    float3 n;
    float2 uv;
};

struct GBufferData {
    float4 albedoRoughness      [[color(0)]];
    float4 normalMetallic       [[color(1)]];
    float4 positionReflectance  [[color(2)]];
};

vertex RasterizerData gBufferVertex(Vertex                      in              [[stage_in]],
                                    constant CameraUniforms &   cameraUniforms  [[buffer(1)]],
                                    constant ModelUniforms &    modelUniforms   [[buffer(2)]]) {
    float4 worldPosition = modelUniforms.modelMatrix * float4(in.position, 1);
    
    RasterizerData out;
    out.t = normalize(in.tangent);
    out.b = normalize(cross(in.tangent, in.normal));
    out.n = normalize(in.normal);
    out.clipSpacePosition = cameraUniforms.projectionMatrix * cameraUniforms.viewMatrix * worldPosition;
    out.worldSpacePosition = worldPosition.xyz;
    out.uv = in.textureUV;
    return out;
}

fragment GBufferData gBufferFragment(RasterizerData             in              [[stage_in]],
                                     texture2d<float>           albedo          [[texture(0)]],
                                     texture2d<float>           roughness       [[texture(1)]],
                                     texture2d<float>           normals         [[texture(2)]],
                                     texture2d<float>           metallic        [[texture(3)]],
                                     constant ModelUniforms &   modelUniforms   [[buffer(2)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::nearest, address::mirrored_repeat);
    simd_float3x3 TBN(in.t, in.b, in.n);
    GBufferData out;
    // 0.04 is reflactance for common materials
    // should be possible to configure it
    float3 normalEncoded = normals.sample(textureSampler, in.uv).xyz;
    float3 normalDecoded = (normalEncoded * 2) - 1;
    float3 worldTranslation = (modelUniforms.modelMatrix * float4(0, 0, 0, 1)).xyz;
    float3 normalWorldSpace = (modelUniforms.modelMatrix * float4(TBN * normalDecoded, 1)).xyz - worldTranslation;
    out.positionReflectance = float4(in.worldSpacePosition, 0.04);
    out.albedoRoughness = float4(albedo.sample(textureSampler, in.uv).xyz, roughness.sample(textureSampler, in.uv).x);
    out.normalMetallic = float4(normalWorldSpace, metallic.sample(textureSampler, in.uv).x);
    return out;
}

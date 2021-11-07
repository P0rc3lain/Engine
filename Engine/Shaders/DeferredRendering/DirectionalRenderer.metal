//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "../Common/PBR.h"
#include "../../MetalBinding/Model.h"
#include "../../MetalBinding/Vertex.h"
#include "../../MetalBinding/Camera.h"
#include "../../MetalBinding/Attribute.h"
#include "../../MetalBinding/Light/DirectionalLight.h"

using namespace metal;

struct RasterizerData {
    float4 position [[position]];
    float2 texcoord;
    uint instanceId [[flat]];
};

vertex RasterizerData vertexDirectionalLight(Vertex in [[stage_in]],
                                             uint instanceId [[instance_id]]) {
    return RasterizerData {
        float4(in.position, 1),
        in.textureUV,
        instanceId
    };
}

fragment float4 fragmentDirectionalLight(RasterizerData in [[stage_in]],
                                         texture2d<float> ar [[texture(kAttributeDirectionalFragmentShaderTextureAR)]],
                                         texture2d<float> nm [[texture(kAttributeDirectionalFragmentShaderTextureNM)]],
                                         texture2d<float> pr [[texture(kAttributeDirectionalFragmentShaderTexturePR)]],
                                         constant CameraUniforms & camera [[buffer(kAttributeDirectionalFragmentShaderBufferCamera)]],
                                         constant DirectionalLight * directionalLights [[buffer(kAttributeDirectionalFragmentShaderBufferDirectionalLights)]],
                                         constant ModelUniforms * lightUniforms [[buffer(kAttributeDirectionalFragmentShaderBufferLightUniforms)]]) {
    constexpr sampler textureSampler(mag_filter::nearest, min_filter::nearest);
    float4 arV = ar.sample(textureSampler, in.texcoord);
    float4 nmV = nm.sample(textureSampler, in.texcoord);
    float4 prV = pr.sample(textureSampler, in.texcoord);
    // Camera Space Position
    float3 fragmentPosition = prV.xyz;
    float reflectance = prV.w;

    float3 n = nmV.xyz;
    float metallicFactor = nmV.w;

    float3 baseColor = arV.xyz;
    float roughnessFactor = arV.w;

    float3 cameraPosition = float3(0, 0, 0);
    float3 eye = normalize(cameraPosition - fragmentPosition);

    float3 outputColor(0, 0, 0);
    DirectionalLight light = directionalLights[in.instanceId];
    float3 l = normalize(-light.direction);
    float3 halfway = normalize(l + eye);
    float3 f0 = 0.16 * reflectance * reflectance * (1 - metallicFactor) + metallicFactor * baseColor;
    float3 specular = cookTorrance(n, eye, halfway, l, roughnessFactor, f0);
    float3 diffuseColor = (1 - metallicFactor) * baseColor;
    float3 color =  diffuseColor / M_PI_F + specular;
    outputColor += color * directionalLights[in.instanceId].color * dot(n, l) * directionalLights[in.instanceId].intensity;
    return float4(outputColor, 1);
}

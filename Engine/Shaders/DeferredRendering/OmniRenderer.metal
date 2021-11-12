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
#include "../../MetalBinding/Light/OmniLight.h"

using namespace metal;

struct RasterizerData {
    float4 position [[position]];
    float2 texcoord;
    uint instanceId [[flat]];
};

vertex RasterizerData vertexDeferredLight(VertexPUV in [[stage_in]],
                                          uint instanceId [[instance_id]]) {
    return RasterizerData {
        float4(in.position, 1),
        in.textureUV,
        instanceId
    };
}

fragment float4 fragmentDeferredLight(RasterizerData in [[stage_in]],
                                      texture2d<float> ar [[texture(kAttributeLightingFragmentShaderTextureAR)]],
                                      texture2d<float> nm [[texture(kAttributeLightingFragmentShaderTextureNM)]],
                                      texture2d<float> pr [[texture(kAttributeLightingFragmentShaderTexturePR)]],
                                      depthcube_array<float> shadows [[texture(kAttributeLightingFragmentShaderTextureShadowMaps)]],
                                      constant CameraUniforms & camera [[buffer(kAttributeLightingFragmentShaderBufferCamera)]],
                                      constant OmniLight * omniLights [[buffer(kAttributeLightingFragmentShaderBufferOmniLights)]],
                                      constant ModelUniforms * lightUniforms [[buffer(kAttributeLightingFragmentShaderBufferLightUniforms)]]) {
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
    OmniLight light = omniLights[in.instanceId];
    float3 lightPosition = (lightUniforms[camera.index].modelMatrix * lightUniforms[light.idx].modelMatrix * float4(0, 0, 0, 1)).xyz;
    float3 l = normalize(lightPosition - fragmentPosition);
    if (dot(n, l) < 0) {
        discard_fragment();
    }
    
    // Shadow
    float4 lightSpacesFragmentPosition = lightUniforms[light.idx].modelMatrixInverse * lightUniforms[camera.index].modelMatrixInverse * float4(fragmentPosition, 1);
    float currentDistance = length(lightSpacesFragmentPosition.xyz)/100;
    float3 sampleVector = normalize(lightSpacesFragmentPosition.xyz);
    sampleVector.x = -sampleVector.x;
    float existingDistance = shadows.sample(textureSampler, sampleVector, in.instanceId);
    bool inShadow = currentDistance > existingDistance;
    if (inShadow) {
        discard_fragment();
    }
    
    float3 halfway = normalize(l + eye);
    float3 f0 = 0.16 * reflectance * reflectance * (1 - metallicFactor) + metallicFactor * baseColor;
    float3 specular = cookTorrance(n, eye, halfway, l, roughnessFactor, f0);
    float3 diffuseColor = (1 - metallicFactor) * baseColor;
    float3 color =  diffuseColor / M_PI_F + specular;
    outputColor += color * omniLights[in.instanceId].color * dot(n, l) * omniLights[in.instanceId].intensity;
    return float4(outputColor, 1);
}

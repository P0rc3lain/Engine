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
#include "../../MetalBinding/Light/SpotLight.h"

using namespace metal;

struct RasterizerData {
    float4 position [[position]];
    float2 texcoord;
    uint instanceId [[flat]];
};

vertex RasterizerData vertexSpotLight(Vertex in [[stage_in]],
                                      uint instanceId [[instance_id]]) {
    return RasterizerData {
        float4(in.position, 1),
        in.textureUV,
        instanceId
    };
}

fragment float4 fragmentSpotLight(RasterizerData in [[stage_in]],
                                  texture2d<float> ar [[texture(kAttributeDirectionalFragmentShaderTextureAR)]],
                                  texture2d<float> nm [[texture(kAttributeDirectionalFragmentShaderTextureNM)]],
                                  texture2d<float> pr [[texture(kAttributeDirectionalFragmentShaderTexturePR)]],
                                  depth2d_array<float> shadowMaps [[texture(kAttributeSpotFragmentShaderTextureShadowMaps)]],
                                  constant CameraUniforms & camera [[buffer(kAttributeDirectionalFragmentShaderBufferCamera)]],
                                  constant SpotLight * spotLights [[buffer(kAttributeDirectionalFragmentShaderBufferDirectionalLights)]],
                                  constant ModelUniforms * modelUniforms [[buffer(kAttributeDirectionalFragmentShaderBufferLightUniforms)]]) {
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
    SpotLight light = spotLights[in.instanceId];
    int id = light.idx;
    float4x4 lightTransformation = modelUniforms[camera.index].modelMatrix * modelUniforms[id].modelMatrix;
    float3 lightPosition = (lightTransformation * float4(float3(0), 1)).xyz;
    float3 forwardDirection = normalize(lightTransformation.columns[2].xyz);
    float3 l = normalize(lightPosition - fragmentPosition);
    float theta = acos(dot(forwardDirection, l));
    if (theta > light.coneAngle/2) {
        discard_fragment();
    }
    
    float4 lightSpacesFragmentPosition = modelUniforms[id].modelMatrixInverse * modelUniforms[camera.index].modelMatrixInverse * float4(fragmentPosition, 1);
    float4 lightProjectedPosition = light.projectionMatrix * lightSpacesFragmentPosition;
    lightProjectedPosition /= lightProjectedPosition.w;
    lightProjectedPosition.xy = lightProjectedPosition.xy * 0.5 + 0.5;
    lightProjectedPosition.y = 1.0 - lightProjectedPosition.y;
    float existingDepth = shadowMaps.sample(textureSampler, lightProjectedPosition.xy, in.instanceId);
    float4 reconstructedPosition = light.projectionMatrixInverse * float4(lightProjectedPosition.xy, existingDepth, 1.0);
    reconstructedPosition /= reconstructedPosition.w;
    float bias = max(0.05 * (1.0 - dot(n, l)), 0.005);

    if (lightSpacesFragmentPosition.z < reconstructedPosition.z - bias) {
        discard_fragment();
    }
    
    float3 halfway = normalize(l + eye);
    float3 f0 = 0.16 * reflectance * reflectance * (1 - metallicFactor) + metallicFactor * baseColor;
    float3 specular = cookTorrance(n, eye, halfway, l, roughnessFactor, f0);
    float3 diffuseColor = (1 - metallicFactor) * baseColor;
    float3 color =  diffuseColor / M_PI_F + specular;
    float3 outputColor = color * spotLights[in.instanceId].color * dot(n, l) * spotLights[in.instanceId].intensity;
    return float4(outputColor, 1);
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "Shaders/Common/PBR.h"
#include "Shaders/Common/LightingInput.h"
#include "Shaders/Common/Transformation.h"

#include "MetalBinding/PNShared/Model.h"
#include "MetalBinding/PNShared/Vertex.h"
#include "MetalBinding/PNShared/Camera.h"
#include "MetalBinding/PNShared/Light/SpotLight.h"
#include "MetalBinding/PNShared/Light/Attenuation.h"

#include "MetalBinding/PNAttribute/Bridge.h"

using namespace metal;

struct RasterizerData {
    float4 position [[position]];
    float2 texcoord;
    uint instanceId [[flat]];
};

vertex RasterizerData vertexSpotLight(Vertex in [[stage_in]],
                                      uint instanceId [[instance_id]]) {
    return {
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
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear, mip_filter::linear);
    LightingInput input = LightingInput::fromTextures(ar, nm, pr, textureSampler, in.texcoord);
    
    float3 cameraPosition = float3(0);
    float3 eye = normalize(cameraPosition - input.fragmentPosition);
    SpotLight light = spotLights[in.instanceId];
    int id = light.idx;
    float4x4 lightTransformation = modelUniforms[camera.index].modelMatrixInverse * modelUniforms[id].modelMatrix;
    float3 lightPosition = extractPosition(lightTransformation).xyz;
    float3 forwardDirection = normalize(lightTransformation.columns[2].xyz);
    float3 fragmentToLight = lightPosition - input.fragmentPosition;
    float attenuationFactor = falloffAttenuation(length_squared(fragmentToLight),
                                                 light.influenceRadius);
    float3 l = normalize(fragmentToLight);
    auto theta = dot(forwardDirection, l);
    auto thetaAngle = acos(theta);
    if (thetaAngle > light.coneAngle / 2 || attenuationFactor == 0) {
        discard_fragment();
    }
    
    auto gamma = cos(light.outerConeAngle/2);
    auto phi = cos(light.innerConeAngle/2);
    float epsilon = phi - gamma;
    float intensity = clamp((theta - gamma) / epsilon, 0.0f, 1.0f);
    
    if (light.castsShadows) {
        constant auto & invModelMatrix = modelUniforms[id].modelMatrixInverse;
        constant auto & invCameraMatrix = modelUniforms[camera.index].modelMatrix;
        float4 lightSpacesFragmentPosition = invModelMatrix * invCameraMatrix * float4(input.fragmentPosition, 1);
        float4 lightProjectedPosition = light.projectionMatrix * lightSpacesFragmentPosition;
        lightProjectedPosition /= lightProjectedPosition.w;
        lightProjectedPosition.xy = lightProjectedPosition.xy * 0.5 + 0.5;
        lightProjectedPosition.y = 1.0 - lightProjectedPosition.y;
        float existingDepth = shadowMaps.sample(textureSampler, lightProjectedPosition.xy, in.instanceId);
        float4 reconstructedPosition = light.projectionMatrixInverse * float4(lightProjectedPosition.xy, existingDepth, 1.0);
        reconstructedPosition /= reconstructedPosition.w;
        float bias = max(0.05 * (1.0 - dot(input.n, l)), 0.005);
        if (lightSpacesFragmentPosition.z < reconstructedPosition.z - bias) {
            discard_fragment();
        }
    }
    return float4(attenuationFactor * intensity * lighting(l,
                                                           eye,
                                                           input,
                                                           light.color,
                                                           light.intensity), 1);
}

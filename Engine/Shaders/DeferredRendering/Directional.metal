//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "../Common/PBR.h"
#include "../Common/Shadow.h"
#include "../Common/LightingInput.h"
#include "../../MetalBinding/Model.h"
#include "../../MetalBinding/Vertex.h"
#include "../../MetalBinding/Camera.h"
#include "../../MetalBinding/Attribute.h"
#include "../../MetalBinding/Light/DirectionalLight.h"

#define PCF_VERTICAL_SAMPELS 2
#define PCF_HORIZONTAL_SAMPLES 2
#define BIAS_MIN 0.005
#define BIAS_MAX 0.05

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
                                         depth2d_array<float> shadowMaps [[texture(kAttributeDirectionalFragmentShaderTextureShadowMaps)]],
                                         constant CameraUniforms & camera [[buffer(kAttributeDirectionalFragmentShaderBufferCamera)]],
                                         constant DirectionalLight * directionalLights [[buffer(kAttributeDirectionalFragmentShaderBufferDirectionalLights)]],
                                         constant ModelUniforms * modelUniforms [[buffer(kAttributeDirectionalFragmentShaderBufferLightUniforms)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear, mip_filter::linear);
    DirectionalLight light = directionalLights[in.instanceId];
    float3 lightDirection = light.rotationMatrix.columns[2].xyz;
    LightingInput input = LightingInput::fromTextures(ar, nm, pr, textureSampler, in.texcoord);
    float3 eye = normalize(-input.fragmentPosition);
    float3 l = normalize(lightDirection);
    if (dot(input.n, l) < 0) {
        discard_fragment();
    }
    float4 lightSpacesFragmentPosition = light.rotationMatrixInverse * modelUniforms[camera.index].modelMatrixInverse * float4(input.fragmentPosition, 1);
    float4 lightProjectedPosition = light.projectionMatrix * lightSpacesFragmentPosition;
    lightProjectedPosition.xy = lightProjectedPosition.xy * 0.5 + 0.5;
    lightProjectedPosition.y = 1.0 - lightProjectedPosition.y;
    float bias = max(BIAS_MAX * (1.0 - dot(input.n, l)), BIAS_MIN);
    float shadow = pcfDepth(shadowMaps,
                            in.instanceId,
                            lightProjectedPosition.xy,
                            int2(PCF_HORIZONTAL_SAMPLES, PCF_VERTICAL_SAMPELS),
                            lightProjectedPosition.z,
                            bias);
    if (shadow == 1) {
        discard_fragment();
    }
    float3 color = lighting(l,
                            eye,
                            input,
                            directionalLights[in.instanceId].color,
                            directionalLights[in.instanceId].intensity);
    return (1 - shadow) * float4(color, 1);
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "Shaders/Common/PBR.h"
#include "Shaders/Common/Shadow.h"
#include "Shaders/Common/LightingInput.h"

#include "MetalBinding/PNShared/Model.h"
#include "MetalBinding/PNShared/Vertex.h"
#include "MetalBinding/PNShared/Camera.h"
#include "MetalBinding/PNShared/Light/DirectionalLight.h"

#include "MetalBinding/PNAttribute/Bridge.h"

constant int2 pcfRange [[function_constant(kFunctionConstantIndexDirectionalPcfRange)]];
constant float2 shadowBias [[function_constant(kFunctionConstantIndexDirectionalShadowBias)]];

using namespace metal;

struct RasterizerData {
    float4 position [[position]];
    float2 texcoord;
    uint instanceId [[flat]];
};

vertex RasterizerData vertexDirectionalLight(Vertex in [[stage_in]],
                                             uint instanceId [[instance_id]]) {
    return {
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
    if (dot(input.n, l) < 0)
        discard_fragment();
    float shadowInfluence{0};
    if (light.castsShadows) {
        float4 lightSpacesFragmentPosition = light.rotationMatrixInverse *
                                             modelUniforms[camera.index].modelMatrix *
                                             float4(input.fragmentPosition, 1);
        float4 lightProjectedPosition = light.projectionMatrix * lightSpacesFragmentPosition;
        lightProjectedPosition.xy = lightProjectedPosition.xy * 0.5 + 0.5;
        lightProjectedPosition.y = 1.0 - lightProjectedPosition.y;
        float bias = max(shadowBias.y * (1.0 - dot(input.n, l)), shadowBias.x);
        shadowInfluence = pcfDepth(shadowMaps,
                                   in.instanceId,
                                   lightProjectedPosition.xy,
                                   pcfRange,
                                   lightProjectedPosition.z,
                                   bias);
        if (shadowInfluence == 1)
            discard_fragment();
    }
    float3 color = lighting(l,
                            eye,
                            input,
                            light.color,
                            light.intensity);
    return (1 - shadowInfluence) * float4(color, 1);
}

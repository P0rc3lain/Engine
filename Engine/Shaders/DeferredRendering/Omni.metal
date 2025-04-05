//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "Shaders/Common/PBR.h"
#include "Shaders/Common/Shadow.h"
#include "Shaders/Common/LightingInput.h"
#include "Shaders/Common/Transformation.h"

#include "MetalBinding/PNShared/Model.h"
#include "MetalBinding/PNShared/Vertex.h"
#include "MetalBinding/PNShared/Camera.h"
#include "MetalBinding/PNShared/Light/OmniLight.h"
#include "MetalBinding/PNShared/Light/Attenuation.h"

#include "MetalBinding/PNAttribute/Bridge.h"

constant int3 pcfRange [[function_constant(kFunctionConstantIndexOmniPcfRange)]];
constant float2 shadowBias [[function_constant(kFunctionConstantIndexOmniShadowBias)]];

using namespace metal;

struct RasterizerData {
    float4 position [[position]];
    float2 texcoord;
    uint instanceId [[flat]];
};

vertex RasterizerData vertexOmniLight(Vertex in [[stage_in]],
                                      uint instanceId [[instance_id]]) {
    return {
        float4(in.position, 1),
        in.textureUV,
        instanceId
    };
}

fragment float4 fragmentOmniLight(RasterizerData in [[stage_in]],
                                  texture2d<float> ar [[texture(kAttributeLightingFragmentShaderTextureAR)]],
                                  texture2d<float> nm [[texture(kAttributeLightingFragmentShaderTextureNM)]],
                                  texture2d<float> pr [[texture(kAttributeLightingFragmentShaderTexturePR)]],
                                  depthcube_array<float> shadows [[texture(kAttributeLightingFragmentShaderTextureShadowMaps)]],
                                  constant CameraUniforms & camera [[buffer(kAttributeLightingFragmentShaderBufferCamera)]],
                                  constant OmniLight * omniLights [[buffer(kAttributeLightingFragmentShaderBufferOmniLights)]],
                                  constant ModelUniforms * lightUniforms [[buffer(kAttributeLightingFragmentShaderBufferLightUniforms)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear, mip_filter::linear);
    LightingInput input = LightingInput::fromTextures(ar, nm, pr, textureSampler, in.texcoord);

    float3 eye = normalize(-input.fragmentPosition);
    
    OmniLight light = omniLights[in.instanceId];
    float4x4 transformation = lightUniforms[camera.index].modelMatrixInverse * lightUniforms[light.idx].modelMatrix;
    float3 lightPosition = extractPosition(transformation).xyz;
    float3 fragmentToLight = lightPosition - input.fragmentPosition;
    float attenuationFactor = falloffAttenuation(length_squared(fragmentToLight),
                                                 light.influenceRadius);
    float3 l = normalize(fragmentToLight);
    if (dot(input.n, l) < 0 || attenuationFactor == 0)
        discard_fragment();
    
    float shadowInfluence = 0;
    if (light.castsShadows) {
        // Shadow
        float4 lightSpacesFragmentPosition = lightUniforms[light.idx].modelMatrixInverse *
                                             lightUniforms[camera.index].modelMatrix *
                                             float4(input.fragmentPosition, 1);
        float currentDistance = length(lightSpacesFragmentPosition.xyz)/100;
        float3 sampleVector = normalize(lightSpacesFragmentPosition.xyz);
        sampleVector = -sampleVector;
        float bias = max(shadowBias.y * (1.0 - dot(input.n, l)), shadowBias.x);
        float shadowInfluence = pcfDepth(shadows,
                                         in.instanceId,
                                         sampleVector,
                                         pcfRange,
                                         currentDistance,
                                         bias,
                                         0.01);
        if (shadowInfluence == 1)
            discard_fragment();
    }
    float3 color = lighting(l,
                            eye,
                            input,
                            light.color,
                            light.intensity);
    return float4(attenuationFactor * (1 - shadowInfluence) * color, 1);
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "Shaders/Common/PBR.h"
#include "Shaders/Common/Shadow.h"
#include "Shaders/Common/LightingInput.h"

#include "MetalBinding/Model.h"
#include "MetalBinding/Vertex.h"
#include "MetalBinding/Camera.h"
#include "MetalBinding/Light/OmniLight.h"
#include "MetalBinding/Attribute/Bridge.h"

using namespace metal;

struct RasterizerData {
    float4 position [[position]];
    float2 texcoord;
    uint instanceId [[flat]];
};

vertex RasterizerData vertexDeferredLight(Vertex in [[stage_in]],
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
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear, mip_filter::linear);
    LightingInput input = LightingInput::fromTextures(ar, nm, pr, textureSampler, in.texcoord);

    float3 eye = normalize(-input.fragmentPosition);
    
    OmniLight light = omniLights[in.instanceId];
    float4x4 transformation = lightUniforms[camera.index].modelMatrix * lightUniforms[light.idx].modelMatrix;
    float3 lightPosition = (transformation * float4(float3(0), 1)).xyz;
    float3 l = normalize(lightPosition - input.fragmentPosition);
    if (dot(input.n, l) < 0)
        discard_fragment();
    
    // Shadow
    float4 lightSpacesFragmentPosition = lightUniforms[light.idx].modelMatrixInverse * lightUniforms[camera.index].modelMatrixInverse * float4(input.fragmentPosition, 1);
    float currentDistance = length(lightSpacesFragmentPosition.xyz)/100;
    float3 sampleVector = normalize(lightSpacesFragmentPosition.xyz);
    sampleVector = -sampleVector;
    float bias = max(0.0001 * (1.0 - dot(input.n, l)), 0.00001);
    
    float shadowInfluence = pcfDepth(shadows,
                                     in.instanceId,
                                     sampleVector,
                                     int3{3, 3, 3},
                                     currentDistance,
                                     bias,
                                     0.01);
    float3 color = lighting(l,
                            eye,
                            input,
                            omniLights[in.instanceId].color,
                            omniLights[in.instanceId].intensity);
    return  float4((1 - shadowInfluence) * color, 1);
}

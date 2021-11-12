//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "../Common/PBR.h"
#include "../Common/LightingInput.h"
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

vertex RasterizerData vertexDirectionalLight(VertexPUV in [[stage_in]],
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
    LightingInput input = LightingInput::fromTextures(ar, nm, pr, textureSampler, in.texcoord);

    float3 cameraPosition = float3(0, 0, 0);
    float3 eye = normalize(cameraPosition - input.fragmentPosition);

    float3 outputColor(0, 0, 0);
    DirectionalLight light = directionalLights[in.instanceId];
    float3 l = normalize(-light.direction);
    if (dot(input.n, l) < 0) {
        discard_fragment();
    }
    float3 halfway = normalize(l + eye);
    float3 f0 = 0.16 * input.reflectance * input.reflectance * (1 - input.metallicFactor) + input.metallicFactor * input.baseColor;
    float3 specular = cookTorrance(input.n, eye, halfway, l, input.roughnessFactor, f0);
    float3 diffuseColor = (1 - input.metallicFactor) * input.baseColor;
    float3 color =  diffuseColor / M_PI_F + specular;
    outputColor += color * directionalLights[in.instanceId].color * dot(input.n, l) * directionalLights[in.instanceId].intensity;
    return float4(outputColor, 1);
}

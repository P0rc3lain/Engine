//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <simd/simd.h>
#include <metal_stdlib>

#include "Shaders/Common/Transformation.h"

#include "MetalBinding/PNShared/Model.h"
#include "MetalBinding/PNShared/Vertex.h"
#include "MetalBinding/PNShared/Camera.h"
#include "MetalBinding/PNShared/Light/AmbientLight.h"

#include "MetalBinding/PNAttribute/Bridge.h"

using namespace metal;

struct RasterizerData {
    float4 position [[position]];
    float2 texcoord;
    uint instanceId [[flat]];
};

vertex RasterizerData vertexAmbientLight(Vertex in [[stage_in]],
                                         uint instanceId [[instance_id]]) {
    return RasterizerData {
        float4(in.position, 1),
        in.textureUV,
        instanceId
    };
}

fragment float4 fragmentAmbientLight(RasterizerData in [[stage_in]],
                                     constant ModelUniforms * modelUniforms [[buffer(kAttributeAmbientFragmentShaderBufferModelUniforms)]],
                                     constant AmbientLight * ambientLights [[buffer(kAttributeAmbientFragmentShaderBufferAmbientLights)]],
                                     constant CameraUniforms & camera [[buffer(kAttributeAmbientFragmentShaderBufferCamera)]],
                                     texture2d<float> ar [[texture(kAttributeAmbientFragmentShaderTextureAR)]],
                                     texture2d<float> pr [[texture(kAttributeAmbientFragmentShaderTexturePR)]],
                                     texture2d<float> ssao [[texture(kAttributeAmbientFragmentShaderTextureSSAO)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear, mip_filter::linear);
    float3 fragmentPosition = pr.sample(textureSampler, in.texcoord).xyz;
    float4x4 lightTransformation = modelUniforms[ambientLights[in.instanceId].idx].modelMatrix;
    float3 lightPosition = (modelUniforms[camera.index].modelMatrixInverse * extractPosition(lightTransformation)).xyz;
    if (length(fragmentPosition - lightPosition) < ambientLights[in.instanceId].diameter / 2) {
        float occlusion = ssao.sample(textureSampler, in.texcoord).x;
        float3 finalColor = ambientLights[in.instanceId].intensity * ambientLights[in.instanceId].color;
        return float4(finalColor * ar.sample(textureSampler, in.texcoord).xyz * occlusion, 1);
    } else {
        return float4(0);
    }
}

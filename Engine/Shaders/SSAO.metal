//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "../MetalBinding/Vertex.h"
#include "../MetalBinding/Camera.h"
#include "../MetalBinding/Model.h"
#include "../MetalBinding/Attribute.h"

using namespace metal;

struct RasterizedData {
    float4 position [[position]];
    float2 texcoord;
};

vertex RasterizedData vertexSSAO(Vertex in [[stage_in]]) {
    return RasterizedData {
        float4(in.position, 1),
        in.textureUV
    };
}

fragment float4 fragmentSSAO(RasterizedData in [[stage_in]],
                             texture2d<float> nm [[texture(kAttributeSsaoFragmentShaderTextureNM)]],
                             texture2d<float> pr [[texture(kAttributeSsaoFragmentShaderTexturePR)]],
                             constant CameraUniforms & camera [[buffer(kAttributeLightingFragmentShaderBufferCamera)]],
                             constant simd_float3 * samples [[buffer(kAttributeSsaoFragmentShaderBufferSamples)]],
                             constant simd_float3 * noise [[buffer(kAttributeSsaoFragmentShaderBufferNoise)]],
                             constant ModelUniforms * modelUniforms [[buffer(kAttributeSsaoFragmentShaderBufferModelUniforms)]]) {
    constexpr sampler textureSampler(mag_filter::nearest, min_filter::nearest);
    int noiseValues = 16;
    int samplesCount = 64;
    float3 worldPosition = pr.sample(textureSampler, in.texcoord).xyz;
    float3 normal = normalize(nm.sample(textureSampler, in.texcoord)).xyz;
    int2 accessCoordinates = int2(in.texcoord * 100);
    float3 randomVector = noise[(accessCoordinates.x + accessCoordinates.y) % noiseValues];
    float3 tangent   = normalize(randomVector - normal * dot(randomVector, normal));
    float3 bitangent = normalize(cross(normal, tangent));
    float3x3 TBN = float3x3(tangent, bitangent, normal);
    float radius = 0.7;
    float occlusion = 0.0;
    float bias = 0.05;
    for(int i = 0; i < samplesCount; ++i)
    {
        float3 neighbourWorldPosition = worldPosition + (TBN * samples[i]) * radius;
        float4 neighbourClipPosition = camera.projectionMatrix * float4(neighbourWorldPosition, 1);
        neighbourClipPosition /= neighbourClipPosition.w;
        neighbourClipPosition = neighbourClipPosition * 0.5 + 0.5;
        float neighbourDepth = pr.sample(textureSampler, float2(neighbourClipPosition.x, 1.0 - neighbourClipPosition.y)).z;
        float rangeCheck = smoothstep(0.0, 1.0, radius / abs(worldPosition.z - neighbourDepth));
        occlusion += (neighbourDepth >= worldPosition.z + bias ? 1.0 : 0.0) * rangeCheck;
    }
    float finalOcclusion = 1.0 - (occlusion / samplesCount);
    return pow(finalOcclusion, 2);
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Common/Random.h"

#include "MetalBinding/PNShared/Model.h"
#include "MetalBinding/PNShared/Camera.h"
#include "MetalBinding/PNShared/Rendering/SSAO.h"

#include "MetalBinding/PNAttribute/Bridge.h"

using namespace metal;

constant int sampleCount [[function_constant(kFunctionConstantIndexSSAOSampleCount)]];

kernel void kernelSSAO(texture2d<float> nm [[texture(kAttributeSsaoComputeShaderTextureNM)]],
                       texture2d<float> pr [[texture(kAttributeSsaoComputeShaderTexturePR)]],
                       texture2d<float, access::write> out [[texture(kAttributeSsaoComputeShaderTextureOutput)]],
                       constant CameraUniforms & camera [[buffer(kAttributeSsaoComputeShaderBufferCamera)]],
                       constant simd_float3 * samples [[buffer(kAttributeSsaoComputeShaderBufferSamples)]],
                       constant simd_float3 * noise [[buffer(kAttributeSsaoComputeShaderBufferNoise)]],
                       constant int32_t & time [[buffer(kAttributeSsaoComputeShaderBufferTime)]],
                       uint3 inposition [[thread_position_in_grid]],
                       uint3 threads [[threads_per_grid]],
                       constant ModelUniforms * modelUniforms [[buffer(kAttributeSsaoComputeShaderBufferModelUniforms)]],
                       constant SSAOUniforms & renderingUniforms [[buffer(kAttributeSsaoComputeShaderBufferRenderingUniforms)]]) {
    auto positionContinuousBuffer = inposition.x + inposition.y * threads.x;
    auto seed = positionContinuousBuffer + time;
    auto random = Random(seed);
    float2 texcoord{float(inposition.x)/float(threads.x), float(inposition.y)/float(threads.y)};
    constexpr sampler textureSampler(filter::linear);
    float3 worldPosition = pr.sample(textureSampler, texcoord).xyz;
    float3 normal = normalize(nm.sample(textureSampler, texcoord)).xyz;
    float3 randomVector = noise[int(random.random() * renderingUniforms.noiseCount)];
    float3 tangent = normalize(randomVector - normal * dot(randomVector, normal));
    float3 bitangent = normalize(cross(normal, tangent));
    float3x3 TBN = float3x3(tangent, bitangent, normal);
    float occlusion = 0.0;
    for(int i = 0; i < sampleCount; ++i) {
        float3 neighbourWorldPosition = worldPosition + (TBN * samples[i]) * renderingUniforms.radius;
        float4 neighbourClipPosition = camera.projectionMatrix * float4(neighbourWorldPosition, 1);
        neighbourClipPosition /= neighbourClipPosition.w;
        neighbourClipPosition = neighbourClipPosition * 0.5 + 0.5;
        float neighbourDepth = pr.sample(textureSampler, float2(neighbourClipPosition.x, 1.0 - neighbourClipPosition.y)).z;
        float rangeCheck = smoothstep(0.0, 1.0, renderingUniforms.radius / abs(worldPosition.z - neighbourDepth));
        occlusion += (neighbourDepth >= worldPosition.z + renderingUniforms.bias ? 1.0 : 0.0) * rangeCheck;
    }
    float finalOcclusion = 1.0 - (occlusion / sampleCount);
    out.write(pow(finalOcclusion, renderingUniforms.power), inposition.xy);
}

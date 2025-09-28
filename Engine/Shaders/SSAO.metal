//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Common/Random.h"

#include "MetalBinding/PNShared/Model.h"
#include "MetalBinding/PNShared/Camera.h"

#include "MetalBinding/PNAttribute/Bridge.h"

using namespace metal;

constant int sampleCount [[function_constant(kFunctionConstantIndexSSAOSampleCount)]];
constant int noiseCount [[function_constant(kFunctionConstantIndexSSAONoiseCount)]];

constant float radius [[function_constant(kFunctionConstantIndexSSAORadius)]];
constant float comparisonBias [[function_constant(kFunctionConstantIndexSSAOBias)]];
constant half power [[function_constant(kFunctionConstantIndexSSAOPower)]];

kernel void kernelSSAO(texture2d<half, access::read> nm [[texture(kAttributeSsaoComputeShaderTextureNM)]],
                       texture2d<float, access::read> pr [[texture(kAttributeSsaoComputeShaderTexturePR)]],
                       texture2d<half, access::write> out [[texture(kAttributeSsaoComputeShaderTextureOutput)]],
                       constant CameraUniforms & camera [[buffer(kAttributeSsaoComputeShaderBufferCamera)]],
                       constant simd_float3 * samples [[buffer(kAttributeSsaoComputeShaderBufferSamples)]],
                       constant simd_float3 * noise [[buffer(kAttributeSsaoComputeShaderBufferNoise)]],
                       constant int32_t & time [[buffer(kAttributeSsaoComputeShaderBufferTime)]],
                       uint2 inposition [[thread_position_in_grid]],
                       constant ModelUniforms * modelUniforms [[buffer(kAttributeSsaoComputeShaderBufferModelUniforms)]]) {
    int positionContinuousBuffer = inposition.x +
                                   inposition.y * out.get_width();
    int seed = positionContinuousBuffer + time;
    Random random = Random(seed);
    uint2 positionXY = inposition.xy;
    float2 texcoord = float2(static_cast<float>(inposition.x) / out.get_width(),
                             static_cast<float>(inposition.y) / out.get_height());
    float2 resolutionMultiplier(pr.get_width(), pr.get_height());
    uint2 prnmSamplePosition = uint2(texcoord * resolutionMultiplier);
    float3 worldPosition = pr.read(prnmSamplePosition).xyz;
    float3 normal = normalize(float3(nm.read(prnmSamplePosition).xyz));
    float3 randomVector = noise[int(random.random() * noiseCount)];
    float3 tangent = normalize(randomVector - normal * dot(randomVector, normal));
    float3 bitangent = normalize(cross(normal, tangent));
    float3x3 TBN = float3x3(tangent, bitangent, normal);
    half occlusion = 0.0;
    for(int i = 0; i < sampleCount; ++i) {
        float3 neighbourWorldPosition = worldPosition + (TBN * samples[i]);
        float4 neighbourClipPosition = camera.projectionMatrix * float4(neighbourWorldPosition, 1);
        neighbourClipPosition /= neighbourClipPosition.w;
        neighbourClipPosition = neighbourClipPosition * 0.5 + 0.5;
        neighbourClipPosition.y = (1 - neighbourClipPosition.y);
        neighbourClipPosition.xy *= resolutionMultiplier;
        uint2 sampleXY = uint2(neighbourClipPosition.xy);
        float neighbourDepth = pr.read(sampleXY).z;
        float depthDiff = abs(worldPosition.z - neighbourDepth);
        float rangeCheck = smoothstep(0.0, 1.0, radius / max(depthDiff, 1e-5));
        occlusion += (neighbourDepth >= worldPosition.z + comparisonBias ? 1.0 : 0.0) * rangeCheck;
    }
    half finalOcclusion = 1.0 - (occlusion / sampleCount);
    out.write(pow(finalOcclusion, power), positionXY);
}

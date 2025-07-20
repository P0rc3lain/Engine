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
constant int noiseCount [[function_constant(kFunctionConstantIndexSSAONoiseCount)]];

constant float radius [[function_constant(kFunctionConstantIndexSSAORadius)]];
constant float comparisonBias [[function_constant(kFunctionConstantIndexSSAOBias)]];
constant float power [[function_constant(kFunctionConstantIndexSSAOPower)]];

kernel void kernelSSAO(texture2d<float> nm [[texture(kAttributeSsaoComputeShaderTextureNM)]],
                       texture2d<float> pr [[texture(kAttributeSsaoComputeShaderTexturePR)]],
                       texture2d<float, access::write> out [[texture(kAttributeSsaoComputeShaderTextureOutput)]],
                       constant CameraUniforms & camera [[buffer(kAttributeSsaoComputeShaderBufferCamera)]],
                       constant simd_float3 * samples [[buffer(kAttributeSsaoComputeShaderBufferSamples)]],
                       constant simd_float3 * noise [[buffer(kAttributeSsaoComputeShaderBufferNoise)]],
                       constant int32_t & time [[buffer(kAttributeSsaoComputeShaderBufferTime)]],
                       uint3 inposition [[thread_position_in_grid]],
                       uint3 threads [[threads_per_grid]],
                       constant ModelUniforms * modelUniforms [[buffer(kAttributeSsaoComputeShaderBufferModelUniforms)]]) {
    int positionContinuousBuffer = inposition.x + inposition.y * threads.x;
    int seed = positionContinuousBuffer + time;
    Random random = Random(seed);
    uint2 positionXY = inposition.xy;
    float3 worldPosition = pr.read(positionXY).xyz;
    float3 normal = normalize(nm.read(positionXY)).xyz;
    float3 randomVector = noise[int(random.random() * noiseCount)];
    float3 tangent = normalize(randomVector - normal * dot(randomVector, normal));
    float3 bitangent = normalize(cross(normal, tangent));
    float3x3 TBN = float3x3(tangent, bitangent, normal);
    float2 resolutionMultiplier(pr.get_width(), pr.get_height());
    float occlusion = 0.0;
    for(int i = 0; i < sampleCount; ++i) {
        float3 neighbourWorldPosition = worldPosition + (TBN * samples[i]) * radius;
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
    float finalOcclusion = 1.0 - (occlusion / sampleCount);
    out.write(pow(finalOcclusion, power), positionXY);
}

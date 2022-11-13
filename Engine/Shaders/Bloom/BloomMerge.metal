//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Math.h"
#include "Shaders/Common/Layer.h"

#include "MetalBinding/Attribute/Bridge.h"

using namespace metal;

#define BLEND_MODE 1
#define SPEED 1.2f
#define INTENSITY 0.04f
#define MEAN 0.0f
#define VARIANCE 0.5f

float4 vignette(float4 fragmentColor, float4 vignetteColor, float2 position, float fromRadius, float toRadius) {
    float radius = length(float2(0.5, 0.5) - position) * 2;
    float ratio = saturate(radius - fromRadius) / (toRadius - fromRadius);
    return mix(fragmentColor, vignetteColor, ratio);
}

float4 grain(float time, float2 texcoord, float3 inputColor) {
    float t = time * float(SPEED);
    float seed = dot(texcoord, float2(12.9898, 78.233));
    float noise = fract(sin(seed) * 43758.5453 + t);
    noise = gaussian(noise, float(MEAN), float(VARIANCE) * float(VARIANCE));
    float3 grain = float3(noise) * (1.0 - inputColor.xyz);
    #if BLEND_MODE == 0
    return float4(grain * INTENSITY + vignetteColor, 1);
    #elif BLEND_MODE == 1
    return float4(screen(inputColor.xyz, grain, INTENSITY), 1);
    #elif BLEND_MODE == 2
    return float4(overlay(inputColor.xyz, grain, INTENSITY), 1);
    #elif BLEND_MODE == 3
    return float4(softLight(inputColor.xyz, grain, INTENSITY), 1);
    #elif BLEND_MODE == 4
    return float4(max(inputColor.xyz, grain * INTENSITY), 1);
    #endif
}

kernel void kernelBloomMerge(texture2d<float, access::read_write> inputTexture [[texture(kAttributeBloomMergeComputeShaderTextureOriginal)]],
                             texture2d<float> brightAreasTexture [[texture(kAttributeBloomMergeComputeShaderTextureBrightAreas)]],
                             constant float & time [[buffer(kAttributeBloomMergeComputeShaderBufferTime)]],
                             uint3 inposition [[thread_position_in_grid]],
                             uint3 threads [[threads_per_grid]]) {
    float2 texcoord{float(inposition.x)/float(threads.x), float(inposition.y)/float(threads.y)};
    float3 originalColor = inputTexture.read(inposition.xy).xyz;
    float3 bloomColor = brightAreasTexture.read(inposition.xy).xyz;
    auto inputColor = float4(bloomColor + originalColor, 1);
    auto vignetteColor = vignette(inputColor, float4(0, 0, 0, 1), texcoord, 0.8, 2);
    auto grainColor = grain(time, texcoord, vignetteColor.xyz);
    inputTexture.write(grainColor, inposition.xy);
}

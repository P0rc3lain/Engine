//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Math.h"
#include "Shaders/Common/Layer.h"

#include "MetalBinding/PNAttribute/Bridge.h"

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

float4 motionBlur(texture2d<float> inputTexture,
                  texture2d<float> velocityTexture,
                  uint2 gid,
                  float scale,
                  unsigned int samples) {
    float2 textureSize = float2(inputTexture.get_width(),
                                inputTexture.get_height());
    float2 uv = float2(gid) / textureSize;

    float2 velocity = velocityTexture.read(gid).xy * scale;
    float4 accumulatedColor = float4(0.0);
    float totalWeight = 0.0;

    for (unsigned int i = 0; i < samples; ++i) {
        float t = float(i) / float(samples - 1);
        float2 offset = velocity * (t - 0.5);
        float2 sampleUV = uv + offset;

        int2 sampleCoord = int2(sampleUV * textureSize);
        sampleCoord = clamp(sampleCoord, int2(0), int2(textureSize - 1));

        float4 sampleColor = inputTexture.read(uint2(sampleCoord));
        accumulatedColor += sampleColor;
        totalWeight += 1.0;
    }

    return accumulatedColor / totalWeight;
}

kernel void kernelBloomMerge(texture2d<float> inputTexture [[texture(kAttributeBloomMergeComputeShaderTextureOriginal)]],
                             texture2d<float> brightAreasTexture [[texture(kAttributeBloomMergeComputeShaderTextureBrightAreas)]],
                             texture2d<float> velocityTexture [[texture(kAttributeBloomMergeComputeShaderTextureVelocities)]],
                             texture2d<float, access::write> outputTexture [[texture(kAttributeBloomMergeComputeShaderTextureOutput)]],
                             constant float & time [[buffer(kAttributeBloomMergeComputeShaderBufferTime)]],
                             uint3 inposition [[thread_position_in_grid]],
                             uint3 threads [[threads_per_grid]]) {
    
    float2 texcoord{float(inposition.x)/float(threads.x),
                    float(inposition.y)/float(threads.y)};
    
    float3 blurredImage = motionBlur(inputTexture,
                                     velocityTexture,
                                     inposition.xy,
                                     1,
                                     10).rgb;
    
    float3 bloomColor = brightAreasTexture.read(inposition.xy).xyz;
    auto inputColor = float4(bloomColor + blurredImage, 1);
    auto vignetteColor = vignette(inputColor, float4(0, 0, 0, 1), texcoord, 0.8, 2);
    auto grainColor = grain(time, texcoord, vignetteColor.xyz);
    outputTexture.write(grainColor, inposition.xy);
}

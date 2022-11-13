//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Math.h"
#include "Shaders/Common/Layer.h"

#include "MetalBinding/Vertex.h"
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

kernel void kernelPostprocessing(texture2d<float, access::read_write> inoutTexture [[texture(kAttributePostprocessingComputeShaderTexture)]],
                           uint3 inposition [[thread_position_in_grid]],
                           uint3 threads [[threads_per_grid]],
                           constant float & time [[buffer(kAttributePostprocessingComputeShaderBufferTime)]]) {
    float2 texcoord{float(inposition.x)/float(threads.x), float(inposition.y)/float(threads.y)};
    auto inputColor = inoutTexture.read(inposition.xy);
    auto vignetteColor = vignette(inputColor, float4(0, 0, 0, 1), texcoord, 0.8, 2);
    float4 finalColor;
    float t = time * float(SPEED);
    float seed = dot(texcoord, float2(12.9898, 78.233));
    float noise = fract(sin(seed) * 43758.5453 + t);
    noise = gaussian(noise, float(MEAN), float(VARIANCE) * float(VARIANCE));
    float3 grain = float3(noise) * (1.0 - vignetteColor.xyz);
    #if BLEND_MODE == 0
    finalColor = float4(grain * INTENSITY + vignetteColor, 1);
    #elif BLEND_MODE == 1
    finalColor = float4(screen(vignetteColor.xyz, grain, INTENSITY), 1);
    #elif BLEND_MODE == 2
    finalColor = float4(overlay(vignetteColor.xyz, grain, INTENSITY), 1);
    #elif BLEND_MODE == 3
    finalColor = float4(softLight(vignetteColor.xyz, grain, INTENSITY), 1);
    #elif BLEND_MODE == 4
    finalColor = float4(max(vignetteColor.xyz, grain * INTENSITY), 1);
    #endif
    inoutTexture.write(finalColor, inposition.xy);
}

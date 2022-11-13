//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "MetalBinding/Attribute/Bridge.h"

using namespace metal;

float4 vignette(float4 fragmentColor, float4 vignetteColor, float2 position, float fromRadius, float toRadius) {
    float radius = length(float2(0.5, 0.5) - position) * 2;
    float ratio = saturate(radius - fromRadius) / (toRadius - fromRadius);
    return mix(fragmentColor, vignetteColor, ratio);
}

kernel void kernelVignette(texture2d<float, access::read_write> inoutTexture [[texture(kAttributeVignetteComputeShaderTexture)]],
                           uint3 inposition [[thread_position_in_grid]],
                           uint3 threads [[threads_per_grid]]) {
    float2 texcoord{float(inposition.x)/float(threads.x), float(inposition.y)/float(threads.y)};
    auto inputColor = inoutTexture.read(inposition.xy);
    auto vignetteColor = vignette(inputColor, float4(1, 0, 0, 1), texcoord, 0.8, 2);
    inoutTexture.write(vignetteColor, inposition.xy);
}

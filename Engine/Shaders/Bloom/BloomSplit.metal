//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Color.h"

#include "MetalBinding/PNAttribute/Bridge.h"

constant half luminanceThreshold [[function_constant(kFunctionConstantIndexBloomThreshold)]];
constant half amplification [[function_constant(kFunctionConstantIndexBloomAmplification)]];

using namespace metal;

kernel void kernelBloomSplit(texture2d<half, access::read> inputTexture [[texture(kAttributeBloomSplitComputeShaderTextureInput)]],
                             texture2d<half, access::write> outputTexture [[texture(kAttributeBloomSplitComputeShaderTextureOutput)]],
                             uint2 inposition [[thread_position_in_grid]]) {
    float2 texcoord = float2(inposition.x / static_cast<float>(outputTexture.get_width()),
                             inposition.y / static_cast<float>(outputTexture.get_height()));
    float2 resolution = float2(inputTexture.get_width(), inputTexture.get_height());
    uint2 inTexel = uint2(texcoord * resolution);
    half3 color = inputTexture.read(inTexel).rgb;
    half mask = luminance(color) > luminanceThreshold;
    half3 amplifiedColor = color * amplification;
    outputTexture.write(half4(mask * amplifiedColor, 1.0h), inposition.xy);
}

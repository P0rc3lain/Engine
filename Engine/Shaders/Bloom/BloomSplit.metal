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
    half3 color = inputTexture.read(inposition.xy).xyz;
    if (luminance(color) > luminanceThreshold) {
        outputTexture.write(half4(color * amplification, 1), inposition.xy);
    } else {
        outputTexture.write(half4(0, 0, 0, 1), inposition.xy);
    }
}

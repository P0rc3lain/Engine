//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "MetalBinding/Attribute/Bridge.h"

using namespace metal;


kernel void kernelBloomMerge(texture2d<float, access::read_write> inputTexture [[texture(kAttributeBloomMergeComputeShaderTextureOriginal)]],
                             texture2d<float> brightAreasTexture [[texture(kAttributeBloomMergeComputeShaderTextureBrightAreas)]],
                             uint3 inposition [[thread_position_in_grid]],
                             uint3 threads [[threads_per_grid]]) {
    float3 originalColor = inputTexture.read(inposition.xy).xyz;
    float3 bloomColor = brightAreasTexture.read(inposition.xy).xyz;
    inputTexture.write(float4(bloomColor + originalColor, 1), inposition.xy);
}

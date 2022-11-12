//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Color.h"

#include "MetalBinding/Vertex.h"

using namespace metal;

kernel void kernelBloomSplit(texture2d<float> inputTexture [[texture(kAttributeBloomSplitComputeShaderTextureInput)]],
                             texture2d<float, access::write> outputTexture [[texture(kAttributeBloomSplitComputeShaderTextureOutput)]],
                             uint3 inposition [[thread_position_in_grid]],
                             uint3 threads [[threads_per_grid]]) {
    constexpr sampler textureSampler(mag_filter::linear,
                                     min_filter::linear,
                                     mip_filter::linear);
    float2 texcoord{float(inposition.x)/float(threads.x), float(inposition.y)/float(threads.y)};
    float3 color = inputTexture.sample(textureSampler, texcoord).xyz;
    outputTexture.write(luminance(color) > 0.7 ? float4(color * 2, 1) : float4(0, 0, 0, 1), inposition.xy);
}

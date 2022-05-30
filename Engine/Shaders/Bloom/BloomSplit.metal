//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "../Common/Color.h"
#include "../../MetalBinding/Vertex.h"

using namespace metal;

struct RasterizedData {
    float4 position [[position]];
    float2 texcoord;
};

vertex RasterizedData vertexBloomSplit(Vertex in [[stage_in]]) {
    return RasterizedData {
        float4(in.position, 1),
        in.textureUV
    };
}

fragment float4 fragmentBloomSplit(RasterizedData in [[stage_in]],
                                   texture2d<float> inputTexture [[texture(kAttributeBloomSplitFragmentShaderTextureInput)]]) {
    constexpr sampler textureSampler(mag_filter::linear,
                                     min_filter::linear,
                                     mip_filter::linear);
    float3 color = inputTexture.sample(textureSampler, in.texcoord).xyz;
    return luminance(color) > 0.7 ? float4(color * 2, 1) : float4(0, 0, 0, 1);
}

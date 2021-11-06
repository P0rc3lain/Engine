//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "../../MetalBinding/Vertex.h"
#include "../../MetalBinding/Attribute.h"

using namespace metal;

struct BloomMergeRasterizedData {
    float4 position [[position]];
    float2 texcoord;
};

vertex BloomMergeRasterizedData  vertexBloomMerge(Vertex in [[stage_in]]) {
    BloomMergeRasterizedData out;
    out.position = float4(in.position, 1);
    out.texcoord = in.textureUV;
    return out;
}

fragment float4 fragmentBloomMerge(BloomMergeRasterizedData in [[stage_in]],
                                   texture2d<float> inputTexture [[texture(kAttributeBloomMergeFragmentShaderTextureOriginal)]],
                                   texture2d<float> brightAreasTexture [[texture(kAttributeBloomMergeFragmentShaderTextureBrightAreas)]]) {
    constexpr sampler textureSampler(mag_filter::nearest, min_filter::nearest);
    float3 originalColor = inputTexture.sample(textureSampler, in.texcoord).xyz;
    float3 bloomColor = brightAreasTexture.sample(textureSampler, in.texcoord).xyz;
    return float4(bloomColor + originalColor, 1);
}

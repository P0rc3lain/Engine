//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "../../MetalBinding/Vertex.h"
#include "../../MetalBinding/Attribute.h"

using namespace metal;

struct RasterizedData {
    float4 position [[position]];
    float2 texcoord;
};

vertex RasterizedData  vertexBloomMerge(Vertex in [[stage_in]]) {
    return RasterizedData {
        float4(in.position, 1),
        in.textureUV
    };
}

fragment float4 fragmentBloomMerge(RasterizedData in [[stage_in]],
                                   texture2d<float> inputTexture [[texture(kAttributeBloomMergeFragmentShaderTextureOriginal)]],
                                   texture2d<float> brightAreasTexture [[texture(kAttributeBloomMergeFragmentShaderTextureBrightAreas)]]) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear, mip_filter::linear);
    float3 originalColor = inputTexture.sample(textureSampler, in.texcoord).xyz;
    float3 bloomColor = brightAreasTexture.sample(textureSampler, in.texcoord).xyz;
    return float4(bloomColor + originalColor, 1);
}

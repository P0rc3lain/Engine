//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "../../MetalBinding/Vertex.h"

using namespace metal;

#define RED_VALUE_WEIGHT 0.2126f
#define GREEN_VALUE_WEIGHT 0.7152f
#define BLUE_VALUE_WEIGHT 0.0722f

struct BloomSplitRasterizedData {
    float4 position [[position]];
    float2 texcoord;
};

float get_luminance(float3 color) {
    return dot(color, float3(RED_VALUE_WEIGHT, GREEN_VALUE_WEIGHT, BLUE_VALUE_WEIGHT));
}

vertex BloomSplitRasterizedData  vertexBloomSplit(Vertex in [[stage_in]]) {
    BloomSplitRasterizedData out;
    out.position = float4(in.position, 1);
    out.texcoord = in.textureUV;
    return out;
}

fragment float4 fragmentBloomSplit(BloomSplitRasterizedData in [[stage_in]],
                                   texture2d<float> inputTexture [[texture(kAttributeBloomSplitFragmentShaderTextureInput)]]) {
    constexpr sampler textureSampler(mag_filter::nearest, min_filter::nearest);
    float3 color = inputTexture.sample(textureSampler, in.texcoord).xyz;
    if (get_luminance(color) > 0.7) {
        return float4(color * 2, 1);
    } else {
        return float4(0, 0, 0, 1);
    }
}

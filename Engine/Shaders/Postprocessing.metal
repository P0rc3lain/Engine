//
//  Postprocessing.metal
//  Engine
//
//  Created by Mateusz Stompór on 06/11/2020.
//

#include <metal_stdlib>

#include "../MetalBinding/Vertex.h"

using namespace metal;

struct TexturePipelineRasterizerData {
    float4 position [[position]];
    float2 texcoord;
};

vertex TexturePipelineRasterizerData  vertexPostprocess(Vertex in [[stage_in]]) {
    TexturePipelineRasterizerData out;
    out.position = float4(in.position, 1);
    out.texcoord = in.textureUV;
    return out;
}

fragment float4 fragmentPostprocess(TexturePipelineRasterizerData in [[stage_in]],
                                    texture2d<float> texture [[texture(0)]]) {
    constexpr sampler textureSampler(min_filter::nearest, mag_filter::nearest);
    return texture.sample(textureSampler, in.texcoord);
}

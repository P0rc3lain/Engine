//
//  Postprocessing.metal
//  Porcelain
//
//  Created by Mateusz Stompór on 06/11/2020.
//

#include <metal_stdlib>

using namespace metal;

struct Sample {
    vector_float2 position;
    vector_float2 uv_coordinate;
};

struct TexturePipelineRasterizerData {
    float4 position [[position]];
    float2 texcoord;
};

vertex TexturePipelineRasterizerData  vertexPostprocess(uint vertexID [[vertex_id]],
                                                        constant Sample *vertices [[buffer(0)]]) {
    TexturePipelineRasterizerData out;
    out.position = float4(vertices[vertexID].position.xy, 0, 1);
    out.texcoord = vertices[vertexID].uv_coordinate;
    return out;
}

fragment float4 fragmentPostprocess(TexturePipelineRasterizerData in [[stage_in]],
                                    texture2d<float> texture [[texture(0)]]) {
    constexpr sampler simpleSampler(min_filter::nearest, mag_filter::nearest);
    return texture.sample(simpleSampler, in.texcoord);
}

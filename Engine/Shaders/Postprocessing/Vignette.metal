//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "../../MetalBinding/Vertex.h"
#include "../../MetalBinding/Attribute.h"

using namespace metal;

struct RasterizerData {
    float4 position [[position]];
    float2 texcoord;
};

vertex RasterizerData vertexVignette(VertexPUV in [[stage_in]]) {
    return RasterizerData {
        float4(in.position, 1),
        in.textureUV
    };
}

float4 vignette(float4 vignetteColor, float2 position, float fromRadius, float toRadius) {
    float radius = length(float2(0.5, 0.5) - position) * 2;
    float ratio = saturate(radius - fromRadius) / (toRadius - fromRadius);
    return smoothstep(float4(1, 1, 1, 1), vignetteColor, ratio);
}

fragment float4 fragmentVignette(RasterizerData in [[stage_in]],
                                    texture2d<float> texture [[texture(kAttributeVignetteFragmentShaderTexture)]]) {
    constexpr sampler textureSampler(min_filter::linear, mag_filter::linear, mip_filter::linear);
    return vignette(float4(0, 0, 0, 1), in.texcoord, 0.9, 1.4) * texture.sample(textureSampler, in.texcoord);
}

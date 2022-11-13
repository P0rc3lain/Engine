//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "Shaders/Common/Math.h"
#include "Shaders/Common/Layer.h"

#include "MetalBinding/Vertex.h"
#include "MetalBinding/Attribute/Bridge.h"

using namespace metal;

#define BLEND_MODE 3
#define SPEED 1.5f
#define INTENSITY 0.04f
#define MEAN 0.0f
#define VARIANCE 0.5f

struct RasterizerData {
    float4 position [[position]];
    float2 texcoord;
    float time;
};

vertex RasterizerData vertexGrain(Vertex in [[stage_in]],
                                  constant float & time [[buffer(kAttributeGrainVertexShaderBufferTime)]]) {
    return RasterizerData {
        float4(in.position, 1),
        in.textureUV,
        time
    };
}

fragment float4 fragmentGrain(RasterizerData in [[stage_in]],
                              texture2d<float> texture [[texture(kAttributeGrainFragmentShaderTexture)]]) {
    constexpr sampler textureSampler(min_filter::nearest, mag_filter::nearest, mip_filter::nearest);
    float3 color = texture.sample(textureSampler, in.texcoord).xyz;
    float t = in.time * float(SPEED);
    float seed = dot(in.texcoord, float2(12.9898, 78.233));
    float noise = fract(sin(seed) * 43758.5453 + t);
    noise = gaussian(noise, float(MEAN), float(VARIANCE) * float(VARIANCE));
    float3 grain = float3(noise) * (1.0 - color.rgb);
    #if BLEND_MODE == 0
    return float4(grain * INTENSITY + color, 1);
    #elif BLEND_MODE == 1
    return float4(screen(color, grain, INTENSITY), 1);
    #elif BLEND_MODE == 2
    return float4(overlay(color, grain, INTENSITY), 1);
    #elif BLEND_MODE == 3
    return float4(softLight(color, grain, INTENSITY), 1);
    #elif BLEND_MODE == 4
    return float4(max(color, grain * INTENSITY), 1);
    #endif
    
}

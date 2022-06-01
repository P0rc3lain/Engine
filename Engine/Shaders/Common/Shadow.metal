//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#include "Shadow.h"

using namespace metal;

float pcfDepth(metal::depth2d_array<float> shadowMaps,
               uint layer,
               float2 sampleCoordinate,
               int2 samples,
               float countedDepth,
               float bias) {
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear, mip_filter::linear);
    float2 textureSize = float2(shadowMaps.get_width(), shadowMaps.get_height());
    float2 texelSize = float2(1.0f) / float2(textureSize);
    float result = 0.0f;
    for (auto i = -samples.x; i <= samples.x; ++i) {
        for (auto j = -samples.y; j <= samples.y; ++j) {
            float2 coordinate = sampleCoordinate + float2(i, j) * texelSize;
            float depth = shadowMaps.sample(textureSampler, coordinate, layer);
            result += countedDepth - bias > depth ? 1.0 : 0.0f;
        }
    }
    return result / float((samples.x * 2 + 1) * (samples.y * 2 + 1));
}

float pcfDepth(metal::depthcube_array<float> shadowMaps,
               uint layer,
               float3 sampleCoordinate,
               int3 samples,
               float countedDepth,
               float bias,
               float offset) {
    constexpr sampler sampler(mag_filter::linear, min_filter::linear, mip_filter::linear);
    float shadow = 0.0f;
    for (float i = -offset; i < offset; i += offset / float(samples.x) * 0.5f) {
        for (float j = -offset; j < offset; j += offset / float(samples.y) * 0.5f) {
            for (float k = -offset; k < offset; k += offset / float(samples.z) * 0.5f) {
                float depth = shadowMaps.sample(sampler, sampleCoordinate + float3(i, j, k), layer);
                shadow += countedDepth - bias > depth ? 1.0f : 0.0f;
            }
        }
    }
    return clamp(shadow / float(samples.x * samples.y * samples.z), 0.0f, 1.0f);
}

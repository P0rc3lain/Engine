//
//  AdaptiveToneMapping.h
//  Porcelain
//
//  Created by Mateusz Stompór on 13/11/2020.
//

#ifndef ADAPTIVE_TONE_MAPPING_H
#define ADAPTIVE_TONE_MAPPING_H

#include <simd/simd.h>
#include <metal_stdlib>

float luminanceAdaptiveTone(float3 color) {
    return metal::dot(color, float3(0.3f, 0.59f, 0.11f));
}

float3 colorExposured(float3 color, float exposure) {
    return 1.0f - metal::exp2(-color * exposure);
}

float adaptiveExposure(metal::texture2d<float> const texture, metal::sampler textureSampler, float2 coordinate) {
    float2 texelSize = float2(1) / float2(texture.get_width(), texture.get_height());
    float bf[25];
    for (int i=0; i < 25; ++i) {
        float2 currentTexel = (coordinate + float2(i % 5 - 2, i / 5 - 2));
        float3 luminance = texture.sample(textureSampler, currentTexel * texelSize).xyz;
        bf[i] = luminanceAdaptiveTone(luminance);
    }
    float weightsSum = 273.0f; // 4 * 26.0 + 4 * 16.0 + 4 * 7.0 + 8 * 4.0 + 4 * 1.0 + 1 * 41.0
    float weightedAvarageLuminance = ((1.0 * (bf[0] + bf[4] + bf[20] + bf[24])) +
                                     (4.0 * (bf[1] + bf[3] + bf[5] + bf[9])) +
                                     (4.0 * (bf[15] + bf[19] + bf[21] + bf[23])) +
                                     (7.0 * (bf[2] + bf[10] + bf[14] + bf[22])) +
                                     (16.0 * (bf[6] + bf[8] + bf[16] + bf[18])) +
                                     (26.0 * (bf[7] + bf[11] + bf[13] + bf[17])) +
                                     (41.0 * bf[12])) / weightsSum;
    return metal::sqrt(8.0f / (weightedAvarageLuminance + 0.25f));
}

#endif /* ADAPTIVE_TONE_MAPPING_H */

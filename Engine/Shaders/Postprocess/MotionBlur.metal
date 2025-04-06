//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#include "MotionBlur.h"

using namespace metal;

float4 motionBlur(texture2d<float> inputTexture,
                  texture2d<float> velocityTexture,
                  uint2 gid,
                  float scale,
                  unsigned int samples) {
    float2 textureSize = float2(inputTexture.get_width(),
                                inputTexture.get_height());
    float2 uv = float2(gid) / textureSize;

    float2 velocity = velocityTexture.read(gid).xy * scale;
    float4 accumulatedColor = float4(0.0);
    float totalWeight = 0.0;

    for (unsigned int i = 0; i < samples; ++i) {
        float t = float(i) / float(samples - 1);
        float2 offset = velocity * (t - 0.5);
        float2 sampleUV = uv + offset;

        int2 sampleCoord = int2(sampleUV * textureSize);
        sampleCoord = clamp(sampleCoord, int2(0), int2(textureSize - 1));

        float4 sampleColor = inputTexture.read(uint2(sampleCoord));
        accumulatedColor += sampleColor;
        totalWeight += 1.0;
    }

    return accumulatedColor / totalWeight;
}

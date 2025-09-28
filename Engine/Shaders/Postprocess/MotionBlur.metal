//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#include "MotionBlur.h"

using namespace metal;

half4 motionBlur(texture2d<half> inputTexture,
                  texture2d<half> velocityTexture,
                  uint2 gid,
                  half scale,
                  unsigned int samples) {
    half2 textureSize = half2(inputTexture.get_width(),
                                inputTexture.get_height());
    half2 uv = half2(gid) / textureSize;

    half2 velocity = velocityTexture.read(gid).xy * scale;
    half4 accumulatedColor = half4(0.0);
    float totalWeight = 0.0;

    for (unsigned int i = 0; i < samples; ++i) {
        half t = half(i) / half(samples - 1);
        half2 offset = velocity * (t - 0.5);
        half2 sampleUV = uv + offset;

        uint2 sampleCoord = uint2(sampleUV * textureSize);
        sampleCoord = clamp(sampleCoord, uint2(0), uint2(textureSize - 1));

        half4 sampleColor = inputTexture.read(sampleCoord);
        accumulatedColor += sampleColor;
        totalWeight += 1.0;
    }

    return accumulatedColor / totalWeight;
}

//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "MotionBlur.h"
#include "Vignette.h"
#include "Grain.h"

#include "MetalBinding/PNAttribute/Bridge.h"

using namespace metal;

kernel void postprocessMerge(texture2d<half, access::sample> inputTexture [[texture(kAttributePostprocessMergeComputeShaderTextureOriginal)]],
                             texture2d<half, access::read> brightAreasTexture [[texture(kAttributePostprocessMergeComputeShaderTextureBrightAreas)]],
                             texture2d<half, access::sample> velocityTexture [[texture(kAttributePostprocessMergeComputeShaderTextureVelocities)]],
                             texture2d<half, access::write> outputTexture [[texture(kAttributePostprocessMergeComputeShaderTextureOutput)]],
                             constant float & time [[buffer(kAttributePostprocessMergeComputeShaderBufferTime)]],
                             uint2 inposition [[thread_position_in_grid]],
                             uint2 threads [[threads_per_grid]]) {
    
    float2 texcoord{float(inposition.x)/float(threads.x),
                    float(inposition.y)/float(threads.y)};
    
    half3 blurredImage = motionBlur(inputTexture,
                                    velocityTexture,
                                    inposition,
                                    1.0h,
                                    5).rgb;
    
    float2 bloomResolution = float2(brightAreasTexture.get_width(),
                                    brightAreasTexture.get_height());
    uint2 bloomTexel = uint2(bloomResolution * texcoord);
    half3 bloomColor = brightAreasTexture.read(bloomTexel).xyz;
    half4 inputColor = half4(bloomColor + blurredImage, 1);
    half4 vignetteColor = vignette(inputColor, half4(0, 0, 0, 1), texcoord, 0.8h, 2.0h);
    half4 grainColor = half4(grain(time, texcoord, vignetteColor.xyz), 1.0h);
    outputTexture.write(grainColor, inposition.xy);
}

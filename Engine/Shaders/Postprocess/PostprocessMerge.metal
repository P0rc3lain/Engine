//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "MotionBlur.h"
#include "Vignette.h"
#include "Grain.h"

#include "MetalBinding/PNAttribute/Bridge.h"

using namespace metal;

kernel void postprocessMerge(texture2d<half> inputTexture [[texture(kAttributePostprocessMergeComputeShaderTextureOriginal)]],
                             texture2d<half> brightAreasTexture [[texture(kAttributePostprocessMergeComputeShaderTextureBrightAreas)]],
                             texture2d<half> velocityTexture [[texture(kAttributePostprocessMergeComputeShaderTextureVelocities)]],
                             texture2d<half, access::write> outputTexture [[texture(kAttributePostprocessMergeComputeShaderTextureOutput)]],
                             constant float & time [[buffer(kAttributePostprocessMergeComputeShaderBufferTime)]],
                             uint2 inposition [[thread_position_in_grid]],
                             uint2 threads [[threads_per_grid]]) {
    
    half2 texcoord{half(inposition.x)/half(threads.x),
                   half(inposition.y)/half(threads.y)};
    
    half3 blurredImage = motionBlur(inputTexture,
                                    velocityTexture,
                                    inposition,
                                    1.0h,
                                    5).rgb;
    
    half3 bloomColor = brightAreasTexture.read(inposition.xy).xyz;
    half4 inputColor = half4(bloomColor + blurredImage, 1);
    half4 vignetteColor = vignette(inputColor, half4(0, 0, 0, 1), texcoord, 0.8h, 2.0h);
    half4 grainColor = half4(grain(time, texcoord, vignetteColor.xyz), 1.0h);
    outputTexture.write(grainColor, inposition.xy);
}

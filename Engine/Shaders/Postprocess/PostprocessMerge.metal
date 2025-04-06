//
//  Copyright © 2025 Mateusz Stompór. All rights reserved.
//

#include <metal_stdlib>

#include "MotionBlur.h"
#include "Vignette.h"
#include "Grain.h"

#include "MetalBinding/PNAttribute/Bridge.h"

using namespace metal;

kernel void postprocessMerge(texture2d<float> inputTexture [[texture(kAttributePostprocessMergeComputeShaderTextureOriginal)]],
                             texture2d<float> brightAreasTexture [[texture(kAttributePostprocessMergeComputeShaderTextureBrightAreas)]],
                             texture2d<float> velocityTexture [[texture(kAttributePostprocessMergeComputeShaderTextureVelocities)]],
                             texture2d<float, access::write> outputTexture [[texture(kAttributePostprocessMergeComputeShaderTextureOutput)]],
                             constant float & time [[buffer(kAttributePostprocessMergeComputeShaderBufferTime)]],
                             uint3 inposition [[thread_position_in_grid]],
                             uint3 threads [[threads_per_grid]]) {
    
    float2 texcoord{float(inposition.x)/float(threads.x),
                    float(inposition.y)/float(threads.y)};
    
    float3 blurredImage = motionBlur(inputTexture,
                                     velocityTexture,
                                     inposition.xy,
                                     1,
                                     5).rgb;
    
    float3 bloomColor = brightAreasTexture.read(inposition.xy).xyz;
    auto inputColor = float4(bloomColor + blurredImage, 1);
    auto vignetteColor = vignette(inputColor, float4(0, 0, 0, 1), texcoord, 0.8, 2);
    auto grainColor = grain(time, texcoord, vignetteColor.xyz);
    outputTexture.write(grainColor, inposition.xy);
}

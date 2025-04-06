//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#pragma once

enum AttributeSsaoComputeShaderTextureIndex {
    kAttributeSsaoComputeShaderTextureAR = 0,
    kAttributeSsaoComputeShaderTextureNM,
    kAttributeSsaoComputeShaderTexturePR,
    kAttributeSsaoComputeShaderTextureOutput
};

enum AttributeBloomSplitComputeShaderTextureIndex {
    kAttributeBloomSplitComputeShaderTextureInput = 0,
    kAttributeBloomSplitComputeShaderTextureOutput
};

enum AttributePostprocessMergeComputeShaderTextureIndex {
    kAttributePostprocessMergeComputeShaderTextureOriginal = 0,
    kAttributePostprocessMergeComputeShaderTextureBrightAreas,
    kAttributePostprocessMergeComputeShaderTextureVelocities,
    kAttributePostprocessMergeComputeShaderTextureOutput,
    kAttributePostprocessMergeComputeShaderBufferTime
};

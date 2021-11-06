//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

#ifndef ATTRIBUTE_H
#define ATTRIBUTE_H

enum VertexAttribute {
    kVertexAttributePositionIndex = 0,
    kVertexAttributeNormalIndex,
    kVertexAttributeTangentIndex,
    kVertexAttributeTextureUV,
    kVertexAttributeJointIndices,
    kVertexAttributeJointWeights
};

enum AttributeGBufferVertexShaderBufferIndex {
    kAttributeGBufferVertexShaderBufferStageIn = 0,
    kAttributeGBufferVertexShaderBufferCameraUniforms,
    kAttributeGBufferVertexShaderBufferModelUniforms,
    kAttributeGBufferVertexShaderBufferMatrixPalettes,
    kAttributeGBufferVertexShaderBufferObjectIndex
};

enum AttributeGBufferFragmentShaderTextureIndex {
    kAttributeGBufferFragmentShaderTextureAlbedo = 0,
    kAttributeGBufferFragmentShaderTextureRoughness,
    kAttributeGBufferFragmentShaderTextureNormals,
    kAttributeGBufferFragmentShaderTextureMetallic
};

enum AttributeSsaoVertexShaderBufferIndex {
    kAttributeSsaoVertexShaderBufferStageIn = 0
};

enum AttributeSsaoFragmentShaderTextureIndex {
    kAttributeSsaoFragmentShaderTextureAR = 0,
    kAttributeSsaoFragmentShaderTextureNM,
    kAttributeSsaoFragmentShaderTexturePR
};

enum AttributeSsaoFragmentShaderBufferIndex {
    kAttributeSsaoFragmentShaderBufferCamera = 0,
    kAttributeSsaoFragmentShaderBufferSamples,
    kAttributeSsaoFragmentShaderBufferNoise,
    kAttributeSsaoFragmentShaderBufferModelUniforms
};

enum AttributeBloomSplitVertexShaderBufferIndex {
    kAttributeBloomSplitVertexShaderBufferStageIn = 0
};

enum AttributeBloomSplitFragmentShaderTextureIndex {
    kAttributeBloomSplitFragmentShaderTextureInput = 0,
};

enum AttributeBloomMergeVertexShaderBufferIndex {
    kAttributeBloomMergeVertexShaderBufferStageIn = 0
};

enum AttributeBloomMergeFragmentShaderTextureIndex {
    kAttributeBloomMergeFragmentShaderTextureOriginal = 0,
    kAttributeBloomMergeFragmentShaderTextureBrightAreas
};

enum AttributeLightingVertexShaderBufferIndex {
    kAttributeLightingVertexShaderBufferStageIn = 0
};

enum AttributeLightingFragmentShaderTextureIndex {
    kAttributeLightingFragmentShaderTextureAR = 0,
    kAttributeLightingFragmentShaderTextureNM,
    kAttributeLightingFragmentShaderTexturePR,
    kAttributeLightingFragmentShaderTextureSSAO
};

enum AttributeLightingFragmentShaderBufferIndex {
    kAttributeLightingFragmentShaderBufferCamera = 0,
    kAttributeLightingFragmentShaderBufferOmniLights,
    kAttributeLightingFragmentShaderBufferLightUniforms
};

enum AttributeEnvironmentVertexShaderBufferIndex {
    kAttributeEnvironmentVertexShaderBufferStageIn = 0,
    kAttributeEnvironmentVertexShaderBufferUniforms
};

enum AttributeEnvironmentFragmentShaderTextureIndex {
    kAttributeEnvironmentFragmentShaderTextureCubeMap = 0
};

enum AttributePostprocessingVertexShaderBufferIndex {
    kAttributePostprocessingVertexShaderBufferStageIn = 0
};

enum AttributePostprocessingFragmentShaderTextureIndex {
    kAttributePostprocessingFragmentShaderTexture = 0
};

#endif /* ATTRIBUTE_H */

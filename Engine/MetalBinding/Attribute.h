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

enum AttributeSpotShadowVertexShaderBufferIndex {
    kAttributeSpotShadowVertexShaderBufferStageIn = 0,
    kAttributeSpotShadowVertexShaderBufferSpotLights,
    kAttributeSpotShadowVertexShaderBufferModelUniforms,
    kAttributeSpotShadowVertexShaderBufferMatrixPalettes,
    kAttributeSpotShadowVertexShaderBufferObjectIndex
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
    kAttributeLightingFragmentShaderTexturePR
};

enum AttributeLightingFragmentShaderBufferIndex {
    kAttributeLightingFragmentShaderBufferCamera = 0,
    kAttributeLightingFragmentShaderBufferOmniLights,
    kAttributeLightingFragmentShaderBufferLightUniforms
};

enum AttributeDirectionalVertexShaderBufferIndex {
    kAttributeDirectionalVertexShaderBufferStageIn = 0
};

enum AttributeDirectionalFragmentShaderTextureIndex {
    kAttributeDirectionalFragmentShaderTextureAR = 0,
    kAttributeDirectionalFragmentShaderTextureNM,
    kAttributeDirectionalFragmentShaderTexturePR
};

enum AttributeDirectionalFragmentShaderBufferIndex {
    kAttributeDirectionalFragmentShaderBufferCamera = 0,
    kAttributeDirectionalFragmentShaderBufferDirectionalLights,
    kAttributeDirectionalFragmentShaderBufferLightUniforms
};

enum AttributeSpotVertexShaderBufferIndex {
    kAttributeSpotVertexShaderBufferStageIn = 0
};

enum AttributeSpotFragmentShaderTextureIndex {
    kAttributeSpotFragmentShaderTextureAR = 0,
    kAttributeSpotFragmentShaderTextureNM,
    kAttributeSpotFragmentShaderTexturePR,
    kAttributeSpotFragmentShaderTextureShadowMaps
};

enum AttributeSpotFragmentShaderBufferIndex {
    kAttributeSpotFragmentShaderBufferCamera = 0,
    kAttributeSpotFragmentShaderBufferSpotLights,
    kAttributeSpotFragmentShaderBufferModelUniforms
};

enum AttributeAmbientVertexShaderBufferIndex {
    kAttributeAmbientVertexShaderBufferStageIn = 0
};

enum AttributeAmbientFragmentShaderTextureIndex {
    kAttributeAmbientFragmentShaderTextureAR = 0,
    kAttributeAmbientFragmentShaderTexturePR,
    kAttributeAmbientFragmentShaderTextureSSAO
};

enum AttributeAmbientFragmentShaderBufferIndex {
    kAttributeAmbientFragmentShaderBufferCamera = 0,
    kAttributeAmbientFragmentShaderBufferAmbientLights,
    kAttributeAmbientFragmentShaderBufferModelUniforms
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

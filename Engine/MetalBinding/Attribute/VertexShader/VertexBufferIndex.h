//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#pragma once

enum AttributeDirectionalShadowVertexShaderBufferIndex {
    kAttributeDirectionalShadowVertexShaderBufferStageIn = 0,
    kAttributeDirectionalShadowVertexShaderBufferDirectionalLights,
    kAttributeDirectionalShadowVertexShaderBufferModelUniforms,
    kAttributeDirectionalShadowVertexShaderBufferMatrixPalettes,
    kAttributeDirectionalShadowVertexShaderBufferObjectIndex,
    kAttributeDirectionalShadowVertexShaderBufferInstanceId
};

enum AttributeOmniShadowVertexShaderBufferIndex {
    kAttributeOmniShadowVertexShaderBufferStageIn = 0,
    kAttributeOmniShadowVertexShaderBufferOmniLights,
    kAttributeOmniShadowVertexShaderBufferModelUniforms,
    kAttributeOmniShadowVertexShaderBufferMatrixPalettes,
    kAttributeOmniShadowVertexShaderBufferObjectIndex,
    kAttributeOmniShadowVertexShaderBufferRotations,
    kAttributeOmniShadowVertexShaderBufferInstanceId
};

enum AttributeGBufferVertexShaderBufferIndex {
    kAttributeGBufferVertexShaderBufferStageIn = 0,
    kAttributeGBufferVertexShaderBufferCameraUniforms,
    kAttributeGBufferVertexShaderBufferModelUniforms,
    kAttributeGBufferVertexShaderBufferMatrixPalettes,
    kAttributeGBufferVertexShaderBufferObjectIndex
};

enum AttributeFogVertexShaderBufferIndex {
    kAttributeFogVertexShaderBufferStageIn = 0,
    kAttributeFogVertexShaderBufferModelUniforms,
    kAttributeFogVertexShaderBufferCamera
};

enum AttributeVignetteVertexShaderBufferIndex {
    kAttributeVignetteVertexShaderBufferStageIn = 0
};

enum AttributeGrainVertexShaderBufferIndex {
    kAttributeGrainVertexShaderBufferStageIn = 0,
    kAttributeGrainVertexShaderBufferTime
};

enum AttributeEnvironmentVertexShaderBufferIndex {
    kAttributeEnvironmentVertexShaderBufferStageIn = 0,
    kAttributeEnvironmentVertexShaderBufferModelUniforms,
    kAttributeEnvironmentVertexShaderBufferCamera
};

enum AttributeSpotShadowVertexShaderBufferIndex {
    kAttributeSpotShadowVertexShaderBufferStageIn = 0,
    kAttributeSpotShadowVertexShaderBufferSpotLights,
    kAttributeSpotShadowVertexShaderBufferModelUniforms,
    kAttributeSpotShadowVertexShaderBufferMatrixPalettes,
    kAttributeSpotShadowVertexShaderBufferObjectIndex,
    kAttributeSpotShadowVertexShaderBufferInstanceId
};

enum AttributeTranslucentVertexShaderBufferIndex {
    kAttributeTranslucentVertexShaderBufferStageIn = 0,
    kAttributeTranslucentVertexShaderBufferCameraUniforms,
    kAttributeTranslucentVertexShaderBufferModelUniforms,
    kAttributeTranslucentVertexShaderBufferMatrixPalettes,
    kAttributeTranslucentVertexShaderBufferObjectIndex,
};

enum AttributeSsaoVertexShaderBufferIndex {
    kAttributeSsaoVertexShaderBufferStageIn = 0
};
enum AttributeDirectionalVertexShaderBufferIndex {
    kAttributeDirectionalVertexShaderBufferStageIn = 0
};

enum AttributeLightingVertexShaderBufferIndex {
    kAttributeLightingVertexShaderBufferStageIn = 0
};

enum AttributeSpotVertexShaderBufferIndex {
    kAttributeSpotVertexShaderBufferStageIn = 0
};

enum AttributeBloomSplitVertexShaderBufferIndex {
    kAttributeBloomSplitVertexShaderBufferStageIn = 0
};

enum AttributeAmbientVertexShaderBufferIndex {
    kAttributeAmbientVertexShaderBufferStageIn = 0
};

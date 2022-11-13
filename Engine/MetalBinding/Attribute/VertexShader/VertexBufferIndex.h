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
    kAttributeFogVertexShaderBufferCameraUniforms
};

enum AttributeEnvironmentVertexShaderBufferIndex {
    kAttributeEnvironmentVertexShaderBufferStageIn = 0,
    kAttributeEnvironmentVertexShaderBufferModelUniforms,
    kAttributeEnvironmentVertexShaderBufferCameraUniforms
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

enum AttributeParticleVertexShaderBufferIndex {
    kAttributeParticleVertexShaderBufferStageIn = 0,
    kAttributeParticleVertexShaderBufferModelUniforms,
    kAttributeParticleVertexShaderBufferCameraUniforms,
    kAttributeParticleVertexShaderBufferSystemIndex
};


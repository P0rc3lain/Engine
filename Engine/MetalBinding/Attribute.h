//
//  Attribute.h
//  Attribute
//
//  Created by Mateusz Stompór on 22/10/2021.
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
    kAttributeGBufferVertexShaderBufferMatrixPalettes
};

enum AttributeGBufferFragmentShaderTextureIndex {
    kAttributeGBufferFragmentShaderTextureAlbedo = 0,
    kAttributeGBufferFragmentShaderTextureRoughness,
    kAttributeGBufferFragmentShaderTextureNormals,
    kAttributeGBufferFragmentShaderTextureMetallic
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

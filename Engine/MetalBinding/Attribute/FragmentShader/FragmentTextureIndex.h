//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#pragma once

enum AttributeFogFragmentShaderTextureIndex {
    kAttributeFogFragmentShaderTextureCubeMap = 0,
    kAttributeFogFragmentShaderTexturePR
};

enum AttributeVignetteFragmentShaderTextureIndex {
    kAttributeVignetteFragmentShaderTexture = 0
};

enum AttributeGrainFragmentShaderTextureIndex {
    kAttributeGrainFragmentShaderTexture = 0
};

enum AttributeEnvironmentFragmentShaderTextureIndex {
    kAttributeEnvironmentFragmentShaderTextureCubeMap = 0
};

enum AttributeTranslucentFragmentShaderTextureIndex {
    kAttributeTranslucentFragmentShaderTextureAlbedo = 0,
};

enum AttributeGBufferFragmentShaderTextureIndex {
    kAttributeGBufferFragmentShaderTextureAlbedo = 0,
    kAttributeGBufferFragmentShaderTextureRoughness,
    kAttributeGBufferFragmentShaderTextureNormals,
    kAttributeGBufferFragmentShaderTextureMetallic
};

enum AttributeAmbientFragmentShaderTextureIndex {
    kAttributeAmbientFragmentShaderTextureAR = 0,
    kAttributeAmbientFragmentShaderTexturePR,
    kAttributeAmbientFragmentShaderTextureSSAO
};

enum AttributeBloomMergeFragmentShaderTextureIndex {
    kAttributeBloomMergeFragmentShaderTextureOriginal = 0,
    kAttributeBloomMergeFragmentShaderTextureBrightAreas
};

enum AttributeLightingFragmentShaderTextureIndex {
    kAttributeLightingFragmentShaderTextureAR = 0,
    kAttributeLightingFragmentShaderTextureNM,
    kAttributeLightingFragmentShaderTexturePR,
    kAttributeLightingFragmentShaderTextureShadowMaps
};

enum AttributeSpotFragmentShaderTextureIndex {
    kAttributeSpotFragmentShaderTextureAR = 0,
    kAttributeSpotFragmentShaderTextureNM,
    kAttributeSpotFragmentShaderTexturePR,
    kAttributeSpotFragmentShaderTextureShadowMaps
};

enum AttributeDirectionalFragmentShaderTextureIndex {
    kAttributeDirectionalFragmentShaderTextureAR = 0,
    kAttributeDirectionalFragmentShaderTextureNM,
    kAttributeDirectionalFragmentShaderTexturePR,
    kAttributeDirectionalFragmentShaderTextureShadowMaps
};

enum AttributeParticleFragmentShaderTextureIndex {
    kAttributeParticleFragmentShaderAtlas = 0,
};

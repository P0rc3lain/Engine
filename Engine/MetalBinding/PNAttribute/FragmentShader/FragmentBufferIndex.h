//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

#pragma once

enum AttributeSpotFragmentShaderBufferIndex {
    kAttributeSpotFragmentShaderBufferCamera = 0,
    kAttributeSpotFragmentShaderBufferSpotLights,
    kAttributeSpotFragmentShaderBufferModelUniforms
};

enum AttributeLightingFragmentShaderBufferIndex {
    kAttributeLightingFragmentShaderBufferCamera = 0,
    kAttributeLightingFragmentShaderBufferOmniLights,
    kAttributeLightingFragmentShaderBufferLightUniforms
};

enum AttributeDirectionalFragmentShaderBufferIndex {
    kAttributeDirectionalFragmentShaderBufferCamera = 0,
    kAttributeDirectionalFragmentShaderBufferDirectionalLights,
    kAttributeDirectionalFragmentShaderBufferLightUniforms
};

enum AttributeAmbientFragmentShaderBufferIndex {
    kAttributeAmbientFragmentShaderBufferCamera = 0,
    kAttributeAmbientFragmentShaderBufferAmbientLights,
    kAttributeAmbientFragmentShaderBufferModelUniforms
};

enum AttributeParticleFragmentShaderBufferIndex {
    kAttributeParticleFragmentShaderBufferUseableTiles = 0,
    kAttributeParticleFragmentShaderBufferGrid
};

enum AttributeGBufferFragmentShaderBufferIndex {
    kAttributeGBufferFragmentShaderBufferMaterial = 0
};

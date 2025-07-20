//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

/// This class provides a centralized location for accessing and modifying configuration settings for various modules.
public struct PNDefaults {
    /// Shared instance of `PNDefaults` for accessing configuration settings.
    public static var shared = PNDefaults()
    /// Configuration for shaders.
    public var shaders = PNShader()
    /// Configuration for rendering settings.
    public var rendering = PNRendering()
    /// Private initializer to prevent external instantiation.
    fileprivate init() {
        // Empty
    }
    /// Rendering configuration.
    public struct PNRendering {
        /// Shadow size configuration.
        public var shadowSize = PNShadowSize()
    }
    /// Shaders configuration.
    public struct PNShader {
        /// Lighting configuration for shaders.
        public var lighting = PNLighting()
        /// Configuration for post-processing effects.
        public var postprocess = PNPostProcess()
    }
    /// Configuration for post-processing effects.
    public struct PNPostProcess {
        /// Configuration for the bloom post-processing effect.
        public var bloom = PNBloom()
    }
    /// Lighting configuration.
    public struct PNLighting {
        /// Configuration for omni-directional lighting.
        public var omniLighting = PNOmniLighting()
        /// Configuration for directional lighting.
        public var directionalLighting = PNDirectionalLighting()
    }
    /// Point light specialized configuration.
    public struct PNOmniLighting {
        /// Range for percentage-closer filtering (PCF) for point lights.
        public var pcfRange = simd_int3(1, 1, 1)
        /// Shadow bias to prevent shadow acne for point lights.
        public var shadowBias = simd_float2(0.005, 0.05)
    }
    /// Directional light specialized configuration.
    public struct PNDirectionalLighting {
        /// Range for percentage-closer filtering (PCF) for directional lights.
        public var pcfRange = simd_int2(1, 1)
        /// Shadow bias to prevent shadow acne for directional lights.
        public var shadowBias = simd_float2(0.00001, 0.0001)
    }
    /// Shadow resolution configuration.
    public struct PNShadowSize {
        /// Resolution for omni-directional shadows.
        public var omni = simd_uint2(512, 512)
        /// Resolution for directional shadows.
        public var directional = simd_uint2(512, 512)
        /// Resolution for spot shadows.
        public var spot = simd_uint2(512, 512)
    }
    /// Configuration for bloom post-processing effect.
    public struct PNBloom {
        /// The minimum luminance a pixel must have to be considered for the bloom effect.
        public var luminanceThreshold: Float = 0.7
        /// Amplifies the brightness of pixels that pass the luminance threshold for bloom.
        public var luminanceAmplifier: Float = 1.2
        /// The sigma value for the Gaussian blur applied to blooming areas.
        public var blurSigma: Float = 10.0
    }
}


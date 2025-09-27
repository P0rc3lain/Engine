//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

/// This class provides a centralized location for accessing and modifying configuration settings for various modules.
public struct PNDefaults {
    /// Shared instance of `PNDefaults` for accessing configuration settings.
    public static var shared = PNDefaults()
    /// Configuration for shader-related effects and parameters.
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
        /// SSAO configuration.
        public var ssao = SSAO()
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
        public var luminanceThreshold: Float16 = 0.7
        /// Amplifies the brightness of pixels that pass the luminance threshold for bloom.
        public var luminanceAmplifier: Float16 = 1.2
        /// The sigma value for the Gaussian blur applied to blooming areas.
        public var blurSigma: Float = 10.0
    }
    /// Configuration for Screen Space Ambient Occlusion (SSAO) visual effect.
    /// SSAO simulates subtle self-shadowing in creases, holes, and surfaces to enhance realism in rendered images. These parameters control the visual quality and performance of the effect.
    public struct SSAO {
        /// The number of hemisphere samples used per pixel for SSAO calculation. Higher values improve quality at the cost of performance.
        public var sampleCount: Int = 8
        /// The number of randomly generated noise vectors. More noise vectors reduce visual banding.
        public var noiseCount: Int = 64
        /// The sampling radius, determining how far to sample around each pixel. Larger radii produce broader occlusion.
        public var radius: Float = 0.2
        /// Bias to reduce self-shadowing and artifacts. Increasing this value can help minimize incorrect darkening.
        public var bias: Float = 0.025
        /// Exponent used to control the strength and contrast of the occlusion effect.
        public var power: Float = 16
        /// Blur sigma
        public var blurSigma: Float = 5.0
    }
}

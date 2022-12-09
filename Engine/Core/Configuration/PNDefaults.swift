//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNDefaults {
    public static var shared = PNDefaults()
    public var shaders = PNShader()
    public var rendering = PNRendering()
    fileprivate init() {
        // Empty
    }
    public struct PNRendering {
        public var shadowSize = PNShadowSize()
    }
    public struct PNShader {
        public var lighting = PNLighting()
    }
    public struct PNLighting {
        public var omniLighting = PNOmniLighting()
        public var directionalLighting = PNDirectionalLighting()
    }
    public struct PNOmniLighting {
        public var pcfRange = simd_int3(1, 1, 1)
        public var shadowBias = simd_float2(0.005, 0.05)
    }
    public struct PNDirectionalLighting {
        public var pcfRange = simd_int2(1, 1)
        public var shadowBias = simd_float2(0.00001, 0.0001)
    }
    public struct PNShadowSize {
        public var omni = simd_uint2(512, 512)
        public var directional = simd_uint2(512, 512)
        public var spot = simd_uint2(512, 512)
    }
}

//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNDefaults {
    public static var shared = PNDefaults()
    public var shaders = PNShader()
    fileprivate init() {
        // Empty
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
        public var shadowBias = simd_float2(0.000_01, 0.000_1)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension simd_float4 {
    public static var defaultNormalsColor: simd_float4 {
        simd_float4(1, 0.5, 0.5, 1)
    }
    public static var defaultBaseColor: simd_float4 {
        simd_float4(0, 1, 0, 1)
    }
    public static var defaultRoughnessColor: simd_float4 {
        simd_float4(1, 1, 1, 1)
    }
    public static var defaultMetallicColor: simd_float4 {
        simd_float4(0, 0, 0, 1)
    }
}

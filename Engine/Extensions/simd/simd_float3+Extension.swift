//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension simd_float3 {
    public var norm: Float {
        sqrtf(dot(self, self))
    }
    public static func random(componentRange: Range<Float> = 0 ..< 1) -> simd_float3 {
        simd_float3(.random(in: componentRange), .random(in: componentRange), .random(in: componentRange))
    }
    public var normalized: simd_float3 {
        self / norm
    }
}

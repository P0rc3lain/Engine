//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension simd_float3 {
    public var norm: Float {
        length(self)
    }
    public static func random(componentRange: Range<Float> = 0 ..< 1) -> simd_float3 {
        simd_float3(.random(in: componentRange),
                    .random(in: componentRange),
                    .random(in: componentRange))
    }
    public var normalized: simd_float3 {
        self / norm
    }
    public func randomPerpendicular(length: Float = 1) -> simd_float3 {
        cross(self, simd_float3.random()).normalized * length
    }
    public init(_ x: Int, _ y: Int, _ z: Int) {
        self.init(Float(x), Float(y), Float(z))
    }
}

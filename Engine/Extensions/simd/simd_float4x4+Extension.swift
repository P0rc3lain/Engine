//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension simd_float4x4 {
    public var translation: simd_float3 {
        columns.3.xyz
    }
    public var rotation: simd_quatf {
        simd_quatf(self)
    }
    public var scale: simd_float3 {
        simd_float3(simd_length(columns.0.xyz),
                    simd_length(columns.1.xyz),
                    simd_length(columns.2.xyz))
    }
    public var decomposed: Position {
        Position(translation: translation, rotation: rotation, scale: scale)
    }
    public init(_ matrix: simd_double4x4) {
        let columns = matrix.columns
        self.init(columns: (simd_float4(columns.0), simd_float4(columns.1), simd_float4(columns.2), simd_float4(columns.3)))
    }
    public static func translation(vector: simd_float3) -> simd_float4x4 {
        simd_float4x4(columns: (simd_float4(1, 0, 0, 0),
                                simd_float4(0, 1, 0, 0),
                                simd_float4(0, 0, 1, 0),
                                simd_float4(vector, 1)))
    }
    public static func scale(_ factors: simd_float3) -> simd_float4x4 {
        simd_float4x4(diagonal: simd_float4(factors, 1))
    }
    public static func perspectiveProjectionRightHand(fovyRadians: simd_float1,
                                                      aspect: simd_float1,
                                                      nearZ: simd_float1,
                                                      farZ: simd_float1) -> simd_float4x4 {
        let yScale = 1 / tan(fovyRadians * 0.5)
        let xScale = yScale / aspect
        let zScale = farZ / (nearZ - farZ)
        return simd_float4x4(rows: [simd_float4(yScale, 0, 0, 0),
                                    simd_float4(0, xScale, 0, 0),
                                    simd_float4(0, 0, zScale, nearZ * zScale),
                                    simd_float4(0, 0, -1, 0 )])
    }
    public static func compose(translation: simd_float3, rotation: simd_quatf, scale: simd_float3) -> simd_float4x4 {
        .translation(vector: translation) * matrix_float4x4(rotation) * .scale(scale)
    }
}

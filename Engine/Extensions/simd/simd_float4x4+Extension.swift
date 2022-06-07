//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension simd_float4x4 {
    public static var identity: simd_float4x4 {
        matrix_identity_float4x4
    }
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
    public var decomposed: PNPosition {
        PNPosition(translation: translation,
                   rotation: rotation,
                   scale: scale)
    }
    public init(_ matrix: simd_double4x4) {
        let columns = matrix.columns
        self.init(columns: (simd_float4(columns.0),
                            simd_float4(columns.1),
                            simd_float4(columns.2),
                            simd_float4(columns.3)))
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
    static func orthographicProjection(left: Float,
                                       right: Float,
                                       top: Float,
                                       bottom: Float,
                                       near: Float,
                                       far: Float) -> simd_float4x4 {
        let sLength = 1.0 / (right - left)
        let aLength = right + left
        let sHeight = 1.0 / (top - bottom)
        let aHeight = top + bottom
        let sDepth = 1.0 / (far - near)
        let p = simd_float4(2 * sLength, 0, 0, 0)
        let q = simd_float4(0, 2 * sHeight, 0, 0)
        let r = simd_float4(0, 0, -sDepth, 0)
        let s = simd_float4(-aLength * sLength, -aHeight * sHeight, -near * sDepth, 1)
        return float4x4(p, q, r, s)
    }
    static func orthographicProjection(bound: PNBound) -> simd_float4x4 {
        orthographicProjection(left: bound.min.x,
                               right: bound.max.x,
                               top: bound.max.y,
                               bottom: bound.min.y,
                               near: bound.min.z,
                               far: bound.max.z)
    }
    public static func from(directionVector: simd_float3) -> simd_float4x4 {
        simd_float3x3.from(directionVector: directionVector).expanded
    }
    public static func compose(translation: simd_float3,
                               rotation: simd_quatf,
                               scale: simd_float3) -> simd_float4x4 {
        .translation(vector: translation) * matrix_float4x4(rotation) * .scale(scale)
    }
}

//
//  simd_float4x4.swift
//  Engine
//
//  Created by Mateusz Stompór on 09/10/2021.
//

import simd

extension simd_float4x4 {
    // MARK: - Properties
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
    public var decomposed: (translation: simd_float3, rotation: simd_quatf, scale: simd_float3) {
        (translation: translation, rotation: rotation, scale: scale)
    }
    // MARK: - Initialization
    public init(_ matrix: simd_double4x4) {
        let columns = matrix.columns
        self.init(columns: (simd_float4(columns.0), simd_float4(columns.1), simd_float4(columns.2), simd_float4(columns.3)))
    }
    // MARK: - Public
    public static func translation(vector: simd_float3) -> simd_float4x4 {
        simd_float4x4(columns:(simd_float4(1,  0, 0, 0),
                               simd_float4(0,  1, 0, 0),
                               simd_float4(0,  0, 1, 0),
                               simd_float4(vector, 1)))
    }
    public static func scale(_ factors: simd_float3) -> simd_float4x4 {
        simd_float4x4(diagonal: simd_float4(factors, 1))
    }
    public static func perspectiveProjectionRightHand(fovyRadians: simd_float1, aspect: simd_float1,
                                                      nearZ: simd_float1, farZ: simd_float1) -> simd_float4x4 {
        let ys = 1 / tan(fovyRadians * 0.5)
        let xs = ys / aspect
        let zs = farZ / (nearZ - farZ);
        return simd_float4x4(rows:[simd_float4(xs, 0,  0, 0),
                                   simd_float4(0, ys, 0, 0),
                                   simd_float4(0,  0, zs, nearZ * zs),
                                   simd_float4(0,  0, -1, 0 )])
    }
}

//
//  CoordinateSpace.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 06/11/2020.
//

import simd

public struct CoordinateSpace {
    // MARK: - Properties
    public var orientation: simd_quatf
    public var translation: simd_float3
    public var scale: simd_float3
    public var transformationTRS: simd_float4x4 {
        return  simd_float4x4.translation(vector: translation) *
                simd_float4x4(orientation) *
                simd_float4x4.scale(scale)
    }
    public var transformationRTS: simd_float4x4 {
        return  simd_float4x4(orientation) *
                simd_float4x4.translation(vector: translation) *
                simd_float4x4.scale(scale)
    }
    // MARK: - Initialization
    public init(translation: simd_float3 = simd_float3(),
                orientation: simd_quatf = simd_quatf(angle: 0, axis: simd_float3(0, 1, 0)),
                scale: simd_float3 = simd_float3(repeating: 1)) {
        self.translation = translation
        self.orientation = orientation
        self.scale = scale
    }
}

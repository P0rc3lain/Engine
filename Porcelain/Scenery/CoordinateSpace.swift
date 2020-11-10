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
    // MARK: - Initialization
    public init(orientation: simd_quatf = simd_quatf(angle: 0, axis: simd_float3(0, 1, 0)),
                translation: simd_float3 = simd_float3(),
                scale: simd_float3 = simd_float3(repeating: 1)) {
        self.orientation = orientation
        self.translation = translation
        self.scale = scale
    }
}

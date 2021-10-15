//
//  Transform.swift
//  Types
//
//  Created by Mateusz Stompór on 11/10/2021.
//

import simd

public struct Transform {
    // MARK: - Properties
    public var coordinateSpace: CoordinateSpace
    public let animation: TransformAnimation
    public var finalTransfrom: simd_float4x4 {
        return coordinateSpace.transformationTRS
    }
    // MARK: - Initialization
    public init(coordinateSpace: CoordinateSpace = CoordinateSpace(),
                animation: TransformAnimation = TransformAnimation()) {
        self.coordinateSpace = coordinateSpace
        self.animation = animation
    }
}

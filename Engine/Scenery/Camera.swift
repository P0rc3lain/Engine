//
//  Camera.swift
//  Engine
//
//  Created by Mateusz Stompór on 06/11/2020.
//

import simd

public struct Camera {
    // MARK: - Properties
    let projectionMatrix: matrix_float4x4
    public var coordinateSpace: CoordinateSpace
    // MARK: - Initialization
    public init(nearPlane: Float, farPlane: Float, fovRadians: Float, aspectRation: Float, coordinateSpace: CoordinateSpace) {
        self.projectionMatrix = matrix_float4x4.perspectiveProjectionRightHand(fovyRadians: fovRadians,
                                                                               aspect: aspectRation,
                                                                               nearZ: nearPlane,
                                                                               farZ: farPlane)
        self.coordinateSpace = coordinateSpace
    }
}

//
//  Transform.swift
//  Types
//
//  Created by Mateusz Stompór on 11/10/2021.
//

public struct Transform {
    // MARK: - Properties
    public var coordinateSpace: CoordinateSpace
    public let animation: TransformAnimation
    // MARK: - Initialization
    public init(coordinateSpace: CoordinateSpace = CoordinateSpace(),
                animation: TransformAnimation = TransformAnimation()) {
        self.coordinateSpace = coordinateSpace
        self.animation = animation
    }
}

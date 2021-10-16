//
//  Entity.swift
//  Types
//
//  Created by Mateusz Stompór on 11/10/2021.
//

public struct Entity {
    // MARK: - Properties
    public var transform: TransformAnimation
    public let type: EntityType
    public let referenceIdx: Int
    // MARK: - Initialization
    public init(transform: TransformAnimation, type: EntityType, referenceIdx: Int) {
        self.transform = transform
        self.type = type
        self.referenceIdx = referenceIdx
    }
}

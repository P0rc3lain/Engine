//
//  PrimitiveType.swift
//  Types
//
//  Created by Mateusz Stompór on 12/10/2021.
//

import Metal
import ModelIO

public enum PrimitiveType: Int {
    // MARK: - Cases
    case points = 0
    case lines = 1
    case triangles = 2
    case triangleStrips = 3
    case quads = 4
    case variableTopology = 5
    // MARK: - Initialization
    public init(modelIO: MDLGeometryType) {
        self = PrimitiveType(rawValue: modelIO.rawValue)!
    }
    // MARK: - Public
    public var metal: MTLPrimitiveType {
        MTLPrimitiveType(rawValue: UInt(rawValue))!
    }
}

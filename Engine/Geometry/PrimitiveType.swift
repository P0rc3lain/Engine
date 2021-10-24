//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
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
        switch self {
            case .triangles:
                return .triangle
            default:
                fatalError("Not implemented")
        }
    }
}

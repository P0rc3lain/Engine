//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import ModelIO

public enum PNPrimitiveType: Int {
    case points = 0
    case lines = 1
    case triangles = 2
    case triangleStrips = 3
    case quads = 4
    case variableTopology = 5
    public init?(modelIO: MDLGeometryType) {
        guard let primitiveType = PNPrimitiveType(rawValue: modelIO.rawValue) else {
            return nil
        }
        self = primitiveType
    }
    public var metal: MTLPrimitiveType {
        switch self {
        case .triangles:
            return .triangle
        default:
            fatalError("Not implemented")
        }
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import ModelIO

/// Type of primitive.
/// In most cases used to describe semantic content of a buffer.
public enum PNPrimitiveType: Int {
    case triangles = 2
    public init?(modelIO: MDLGeometryType) {
        guard let primitiveType = PNPrimitiveType(rawValue: modelIO.rawValue) else {
            assertionFailure("Could not convert primitive")
            return nil
        }
        self = primitiveType
    }
    public var metal: MTLPrimitiveType {
        switch self {
        case .triangles:
            return .triangle
        }
    }
}

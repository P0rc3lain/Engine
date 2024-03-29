//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import ModelIO

/// Describes type width of a value storing an index.
public enum PNIndexBitDepth: UInt {
    case invalid = 0
    case uInt8 = 8
    case uInt16 = 16
    case uInt32 = 32
    public init?(modelIO: MDLIndexBitDepth) {
        guard let indexBitDepth = PNIndexBitDepth(rawValue: modelIO.rawValue) else {
            assertionFailure("Could not convert bit depth")
            return nil
        }
        self = indexBitDepth
    }
    public var metal: MTLIndexType {
        switch self {
        case .uInt16:
            return .uint16
        case .uInt32:
            return .uint32
        default:
            fatalError("Not supported")
        }
    }
}

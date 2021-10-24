//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import ModelIO

public enum IndexBitDepth: UInt {
    // MARK: - Cases
    case invalid = 0
    case uInt8 = 8
    case uInt16 = 16
    case uInt32 = 32
    // MARK: - Initialization
    public init(modelIO: MDLIndexBitDepth) {
        self = IndexBitDepth(rawValue: modelIO.rawValue)!
    }
    // MARK: - Public
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

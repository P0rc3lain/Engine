//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension RawRepresentable where RawValue == UInt32 {
    var int: Int {
        Int(rawValue)
    }
}

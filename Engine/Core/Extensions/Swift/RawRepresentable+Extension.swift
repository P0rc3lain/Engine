//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

extension RawRepresentable where RawValue == UInt32 {
    var int: Int {
        Int(rawValue)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

func ... <T: RawRepresentable>(lhs: T, rhs: T) -> ClosedRange<T.RawValue> where T.RawValue == UInt32 {
    lhs.rawValue ... rhs.rawValue
}

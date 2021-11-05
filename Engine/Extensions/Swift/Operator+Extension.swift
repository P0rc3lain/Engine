//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

func ... <T: RawRepresentable>(lhs: T, rhs: T) -> ClosedRange<T.RawValue> where T.RawValue == UInt32 {
    return lhs.rawValue ... rhs.rawValue
}

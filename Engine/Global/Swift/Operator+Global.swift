//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

func ... <T: RawRepresentable>(lhs: T, rhs: T) -> ClosedRange<T.RawValue> where T.RawValue == UInt32 {
    lhs.rawValue ... rhs.rawValue
}

func cmp <T: Equatable> (_ values: T...) -> Bool {
    guard let first = values.first else {
        return true
    }
    return Array(repeating: first, count: values.count).elementsEqual(values)
}

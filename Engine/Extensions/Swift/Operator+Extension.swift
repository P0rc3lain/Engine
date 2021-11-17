//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

func ... <T: RawRepresentable>(lhs: T, rhs: T) -> ClosedRange<T.RawValue> where T.RawValue == UInt32 {
    lhs.rawValue ... rhs.rawValue
}

func * (lhs: simd_float4x4, rhs: BoundingBox) -> BoundingBox {
    BoundingBox(cornersLower: lhs * rhs.cornersLower,
                cornersUpper: lhs * rhs.cornersUpper)
}

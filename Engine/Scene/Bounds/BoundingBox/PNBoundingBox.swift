//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNBoundingBox: Equatable {
    let cornersLower: simd_float4x4
    let cornersUpper: simd_float4x4
    static var zero: PNBoundingBox {
        let corner = simd_float4x4(repeatingColumn: [0, 0, 0, 1])
        return PNBoundingBox(cornersLower: corner,
                             cornersUpper: corner)
    }
}

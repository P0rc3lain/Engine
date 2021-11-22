//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNBoundingBox {
    let cornersLower: simd_float4x4
    let cornersUpper: simd_float4x4
}

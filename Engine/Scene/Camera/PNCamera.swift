//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNCamera {
    var projectionMatrix: matrix_float4x4 { get }
    var projectionMatrixInverse: matrix_float4x4 { get }
    var boundingBox: PNBoundingBox { get }
}

//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

/// A general interface that camera class must implement to allow rendering from the its perspective.
/// A player's vantage point in a game, eye into the world.
public protocol PNCamera {
    var projectionMatrix: matrix_float4x4 { get }
    var projectionMatrixInverse: matrix_float4x4 { get }
    var boundingBox: PNBoundingBox { get }
}

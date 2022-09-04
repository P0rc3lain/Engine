//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNOmniLight {
    var color: PNColorRGB { get }
    var intensity: Float { get }
    var influenceRadius: Float { get }
    var castsShadows: Bool { get }
    var projectionMatrix: simd_float4x4 { get }
    var projectionMatrixInverse: simd_float4x4 { get }
    var boundingBox: PNBoundingBox { get }
}

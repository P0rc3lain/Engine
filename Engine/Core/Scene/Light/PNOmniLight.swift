//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// A point light is located at a certain point in space and sends light out in all directions equally.
/// The direction of light hitting a surface is the line from the point of contact back to the center of the light object.
/// The intensity diminishes with distance from the light, reaching zero at a specified range.
public protocol PNOmniLight {
    var color: PNColorRGB { get }
    var intensity: Float { get }
    var influenceRadius: Float { get }
    var castsShadows: Bool { get }
    var projectionMatrix: simd_float4x4 { get }
    var projectionMatrixInverse: simd_float4x4 { get }
    var boundingBox: PNBoundingBox { get }
}

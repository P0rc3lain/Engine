//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// A point light is located at a certain point in space and sends light out in all directions equally.
/// The direction of light hitting a surface is the line from the point of contact back to the center of the light object.
/// The intensity diminishes with distance from the light, reaching zero at a specified range.
/// Protocol representing a point (omni-directional) light source.
public protocol PNOmniLight {
    /// The light's color as an RGB vector. Normalized values: 0.0–1.0.
    var color: PNColorRGB { get }
    /// The intensity (brightness) of the light.
    var intensity: Float { get }
    /// The radius beyond which the light has no effect.
    var influenceRadius: Float { get }
    /// Whether this light casts shadows onto objects.
    var castsShadows: Bool { get }
    /// The projection matrix used for shadow mapping or spatial calculations.
    var projectionMatrix: simd_float4x4 { get }
    /// The inverse of the projection matrix.
    var projectionMatrixInverse: simd_float4x4 { get }
    /// The bounding box of the light in world space.
    var boundingBox: PNBoundingBox { get }
    /// The far plane distance for view/projection calculations.
    var farPlane: Float { get }
    /// The near plane distance for view/projection calculations.
    var nearPlane: Float { get }
}

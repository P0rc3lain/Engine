//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Emits light from a single point in a cone shape.
/// Users are given two cones to shape the light - inner and outer.
/// Within the inner cone angle, the light achieves full brightness.
/// As you go from the extent of the inner radius to the extents of the Outer Cone Angle, a falloff takes place, creating a penumbra, or softening around the spot light's disc of illumination.
/// The radius of the light defines the length of the cones. More simply, this will work like a flash light or stage can light.
public protocol PNSpotLight {
    var color: PNColorRGB { get }
    var intensity: Float { get }
    var influenceRadius: Float { get }
    var coneAngle: PNRadians { get }
    var innerConeAngle: PNRadians { get }
    var outerConeAngle: PNRadians { get }
    var castsShadows: Bool { get }
    var projection: PNMatrix4x4FI { get }
    var boundingBox: PNBoundingBox { get }
}

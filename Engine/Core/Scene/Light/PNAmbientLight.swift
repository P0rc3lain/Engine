//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Ambient light has no source and no real direction.
/// This type of light will illuminate each part of the scene equally.
public protocol PNAmbientLight {
    var diameter: Float { get }
    var color: PNColorRGB { get }
    var intensity: Float { get }
    var boundingBox: PNBoundingBox { get }
}

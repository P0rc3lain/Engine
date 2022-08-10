//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNSpotLight {
    var color: PNColorRGB { get }
    var intensity: Float { get }
    var coneAngle: Radians { get }
}

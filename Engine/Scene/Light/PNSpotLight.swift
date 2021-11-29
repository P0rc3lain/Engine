//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNSpotLight {
    var color: simd_float3 { get }
    var intensity: Float { get }
    var coneAngle: Float { get }
}

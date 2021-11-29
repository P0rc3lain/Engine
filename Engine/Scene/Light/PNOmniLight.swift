//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNOmniLight {
    var color: simd_float3 { get }
    var intensity: Float { get }
}

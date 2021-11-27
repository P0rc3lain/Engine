//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNAmbientLight {
    var diameter: Float { get set }
    var color: simd_float3 { get set }
    var intensity: Float { get set }
}

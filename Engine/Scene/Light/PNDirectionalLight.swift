//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNDirectionalLight {
    var color: simd_float3 { get }
    var intensity: Float { get }
    var direction: simd_float3 { get }
    var orientation: simd_float3x3 { get }
}

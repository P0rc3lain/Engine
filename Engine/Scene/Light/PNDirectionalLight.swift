//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNDirectionalLight {
    var color: PNColorRGB { get }
    var intensity: Float { get }
    var direction: simd_float3 { get }
    var castsShadows: Bool { get }
}

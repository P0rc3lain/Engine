//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// The place where entity is located.
public struct PNPosition {
    public let translation: simd_float3
    public let rotation: simd_quatf
    public let scale: simd_float3
}

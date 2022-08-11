//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

extension simd_quatf {
    var rotationMatrix: simd_float4x4 {
        simd_float4x4(self)
    }
}

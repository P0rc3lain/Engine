//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension VertexP {
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.init(position: simd_float3(x, y, z))
    }
}

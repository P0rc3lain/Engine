//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared
import simd

extension Vertex {
    init(position: simd_float3,
         normal: simd_float3,
         tangent: simd_float3,
         textureUV: simd_float2) {
        self.init(position: position,
                  normal: normal,
                  tangent: tangent,
                  textureUV: textureUV,
                  jointIndices: .zero,
                  jointWeights: .zero)
    }
}

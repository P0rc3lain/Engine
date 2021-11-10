//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension OmniLight {
    public static func make(color: simd_float3,
                            intensity: Float,
                            index: Int) -> OmniLight {
        let projectionMatrix = simd_float4x4.perspectiveProjectionRightHand(fovyRadians: Float(90).radians,
                                                                            aspect: 1,
                                                                            nearZ: 0.01,
                                                                            farZ: 100)
        return OmniLight(color: color,
                         intensity: intensity,
                         idx: Int32(index),
                         projectionMatrix: projectionMatrix,
                         projectionMatrixInverse: projectionMatrix.inverse)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct Camera {
    public let projectionMatrix: matrix_float4x4
    public init(nearPlane: Float, farPlane: Float, fovRadians: Float, aspectRatio: Float) {
        self.projectionMatrix = matrix_float4x4.perspectiveProjectionRightHand(fovyRadians: fovRadians,
                                                                               aspect: aspectRatio,
                                                                               nearZ: nearPlane,
                                                                               farZ: farPlane)
    }
}

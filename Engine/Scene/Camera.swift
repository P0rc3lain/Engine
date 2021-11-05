//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct Camera {
    public let projectionMatrix: matrix_float4x4
    public init(nearPlane: Float, farPlane: Float, fovRadians: Float, aspectRation: Float) {
        self.projectionMatrix = matrix_float4x4.perspectiveProjectionRightHand(fovyRadians: fovRadians,
                                                                               aspect: aspectRation,
                                                                               nearZ: nearPlane,
                                                                               farZ: farPlane)
    }
}

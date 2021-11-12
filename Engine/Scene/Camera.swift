//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct Camera {
    let projectionMatrix: matrix_float4x4
    let projectionMatrixInverse: matrix_float4x4
    let boundingBox: BoundingBox
    public init(nearPlane: Float, farPlane: Float, fovRadians: Float, aspectRatio: Float) {
        self.projectionMatrix = matrix_float4x4.perspectiveProjectionRightHand(fovyRadians: fovRadians,
                                                                               aspect: aspectRatio,
                                                                               nearZ: nearPlane,
                                                                               farZ: farPlane)
        self.projectionMatrixInverse = projectionMatrix.inverse
        let ndcBounds: [simd_float3] = [
            [-1, -1, 0],
            [1, -1, 0],
            [-1, -1, 1],
            [1, -1, 1],
            [-1, 1, 0],
            [1, 1, 0],
            [-1, 1, 1],
            [1, 1, 1]
        ]
        self.boundingBox = (projectionMatrixInverse * BoundingBox(corners: ndcBounds)).aabb
    }
}

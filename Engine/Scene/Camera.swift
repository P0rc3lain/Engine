//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct Camera: Identifiable {
    let name: String
    let projectionMatrix: matrix_float4x4
    let projectionMatrixInverse: matrix_float4x4
    let boundingBox: BoundingBox
    public init(name: String,
                nearPlane: Float,
                farPlane: Float,
                fovRadians: Float,
                aspectRatio: Float) {
        projectionMatrix = matrix_float4x4.perspectiveProjectionRightHand(fovyRadians: fovRadians,
                                                                          aspect: aspectRatio,
                                                                          nearZ: nearPlane,
                                                                          farZ: farPlane)
        projectionMatrixInverse = projectionMatrix.inverse
        boundingBox = BoundingBox.projectionBounds(inverseProjection: projectionMatrixInverse)
        self.name = name
    }
}

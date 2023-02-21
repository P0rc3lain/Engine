//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Camera that uses perspective projection.
/// Designed to mimic the way the human eye sees.
public struct PNPerspectiveCamera: PNCamera {
    public let projectionMatrix: matrix_float4x4
    public let projectionMatrixInverse: matrix_float4x4
    public let boundingBox: PNBoundingBox
    public init(nearPlane: Float,
                farPlane: Float,
                fovRadians: Float,
                aspectRatio: Float) {
        projectionMatrix = matrix_float4x4.perspectiveProjectionRightHand(fovyRadians: fovRadians,
                                                                          aspect: aspectRatio,
                                                                          nearZ: nearPlane,
                                                                          farZ: farPlane)
        projectionMatrixInverse = projectionMatrix.inverse
        boundingBox = PNIBoundingBoxInteractor.default.from(inverseProjection: projectionMatrixInverse)
    }
}

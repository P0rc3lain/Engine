//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

/// Camera that uses orthographic projection.
/// In this mode, an object's size in the rendered image stays constant regardless of its distance from the camera.
public struct PNOrthographicCamera: PNCamera {
    public let projectionMatrix: matrix_float4x4
    public let projectionMatrixInverse: matrix_float4x4
    public let boundingBox: PNBoundingBox
    public init(bound: PNBound) {
        projectionMatrix = matrix_float4x4.orthographicProjection(bound: bound)
        projectionMatrixInverse = projectionMatrix.inverse
        boundingBox = PNIBoundingBoxInteractor.default.from(inverseProjection: projectionMatrixInverse)
    }
}

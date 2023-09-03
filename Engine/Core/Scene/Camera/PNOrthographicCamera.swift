//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import simd

/// Camera that uses orthographic projection.
/// In this mode, an object's size in the rendered image stays constant regardless of its distance from the camera.
public struct PNOrthographicCamera: PNCamera {
    public let projection: PNMatrix4x4FI
    public let boundingBox: PNBoundingBox
    public init(bound: PNBound) {
        projection = .from(matrix_float4x4.orthographicProjection(bound: bound))
        boundingBox = PNIBoundingBoxInteractor.default.from(inverseProjection: projection.inv)
    }
}

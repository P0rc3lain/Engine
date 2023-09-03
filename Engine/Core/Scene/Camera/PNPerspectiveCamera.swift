//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Camera that uses perspective projection.
/// Designed to mimic the way the human eye sees.
public struct PNPerspectiveCamera: PNCamera {
    public let projection: PNMatrix4x4FI
    public let boundingBox: PNBoundingBox
    public init(nearPlane: Float,
                farPlane: Float,
                fovRadians: Float,
                aspectRatio: Float) {
        projection = .from(matrix_float4x4.perspectiveProjectionRightHand(fovyRadians: fovRadians,
                                                                          aspect: aspectRatio,
                                                                          nearZ: nearPlane,
                                                                          farZ: farPlane))
        boundingBox = PNIBoundingBoxInteractor.default.from(inverseProjection: projection.inv)
    }
}

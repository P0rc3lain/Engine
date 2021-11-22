//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension SpotLight {
    var boundingBox: PNBoundingBox {
        PNIBoundingBoxInteractor.default.from(inverseProjection: projectionMatrixInverse)
    }
    public static func make(color: simd_float3, intensity: Float, coneAngle: Float, index: Int) -> SpotLight {
        let projectionMatrix = simd_float4x4.perspectiveProjectionRightHand(fovyRadians: coneAngle,
                                                                            aspect: 1,
                                                                            nearZ: 0.01,
                                                                            farZ: 1_000)
        return SpotLight(color: color,
                         intensity: intensity,
                         projectionMatrix: projectionMatrix,
                         projectionMatrixInverse: projectionMatrix.inverse,
                         coneAngle: coneAngle,
                         idx: Int32(index))
    }
}

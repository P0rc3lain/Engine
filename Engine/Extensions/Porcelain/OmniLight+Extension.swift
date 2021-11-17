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
    var boundingBox: BoundingBox {
        let projectionBoundingBox = BoundingBox.projectionBounds(inverseProjection: projectionMatrixInverse)
        // X
        let xPositive = (simd_quatf.environment.positiveX.rotationMatrix * projectionBoundingBox).aabb
        let xNegative = (simd_quatf.environment.negativeX.rotationMatrix * projectionBoundingBox).aabb
        // Y
        let yPositive = (simd_quatf.environment.positiveY.rotationMatrix * projectionBoundingBox).aabb
        let yNegative = (simd_quatf.environment.negativeY.rotationMatrix * projectionBoundingBox).aabb
        // Z
        let zPositive = (simd_quatf.environment.positiveZ.rotationMatrix * projectionBoundingBox).aabb
        let zNegative = (simd_quatf.environment.negativeZ.rotationMatrix * projectionBoundingBox).aabb
        return xPositive.merge(xNegative).merge(yPositive).merge(yNegative).merge(zPositive).merge(zNegative)
    }
}

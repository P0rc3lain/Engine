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
    var boundingBox: PNBoundingBox {
        let interactor = PNIBoundingBoxInteractor.default
        let projectionBoundingBox = interactor.from(inverseProjection: projectionMatrixInverse)
        // X
        let xPositive = interactor.aabb(interactor.multiply(PNSurroundings.positiveX,
                                                            projectionBoundingBox))
        let xNegative = interactor.aabb(interactor.multiply(PNSurroundings.negativeX,
                                                            projectionBoundingBox))
        // Y
        let yPositive = interactor.aabb(interactor.multiply(PNSurroundings.positiveY,
                                                            projectionBoundingBox))
        let yNegative = interactor.aabb(interactor.multiply(PNSurroundings.negativeY,
                                                            projectionBoundingBox))
        // Z
        let zPositive = interactor.aabb(interactor.multiply(PNSurroundings.positiveZ,
                                                            projectionBoundingBox))
        let zNegative = interactor.aabb(interactor.multiply(PNSurroundings.negativeZ,
                                                            projectionBoundingBox))
        let zMerged = interactor.merge(zPositive, zNegative)
        let yMerged = interactor.merge(yPositive, yNegative)
        let xMerged = interactor.merge(xPositive, xNegative)
        return interactor.merge(interactor.merge(xMerged, yMerged), zMerged)
    }
}

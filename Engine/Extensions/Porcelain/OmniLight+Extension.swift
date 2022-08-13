//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding

extension OmniLight {
    public static func make(color: simd_float3,
                            intensity: Float,
                            castsShadows: Bool,
                            index: Int) -> OmniLight {
        let projectionMatrix = simd_float4x4.perspectiveProjectionRightHand(fovyRadians: Float(90).radians,
                                                                            aspect: 1,
                                                                            nearZ: 0.01,
                                                                            farZ: 100)
        return OmniLight(color: color,
                         intensity: intensity,
                         idx: Int32(index),
                         projectionMatrix: projectionMatrix,
                         projectionMatrixInverse: projectionMatrix.inverse,
                         castsShadows: castsShadows ? 1 : 0)
    }
    var boundingBox: PNBoundingBox {
        // TODO: Ensure that calling aabb(interactor.multiply(axis, projection)) is not needed
        let interactor = PNIBoundingBoxInteractor.default
        let projectionBoundingBox = interactor.from(inverseProjection: projectionMatrixInverse)
        guard let boundingBox = [
            interactor.multiply(PNSurroundings.positiveX, projectionBoundingBox),
            interactor.multiply(PNSurroundings.negativeX, projectionBoundingBox),
            interactor.multiply(PNSurroundings.positiveY, projectionBoundingBox),
            interactor.multiply(PNSurroundings.negativeY, projectionBoundingBox),
            interactor.multiply(PNSurroundings.positiveZ, projectionBoundingBox),
            interactor.multiply(PNSurroundings.negativeZ, projectionBoundingBox)
        ].reduce(interactor.merge) else {
            fatalError("Reduce returned nil even if it never should in this circumstances")
        }
        return boundingBox
    }
}

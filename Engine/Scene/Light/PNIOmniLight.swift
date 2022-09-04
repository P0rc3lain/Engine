//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIOmniLight: PNOmniLight {
    public let color: PNColorRGB
    public let intensity: Float
    public var influenceRadius: Float
    public let castsShadows: Bool
    public let projectionMatrix: simd_float4x4
    public let projectionMatrixInverse: simd_float4x4
    public let boundingBox: PNBoundingBox
    public init(color: PNColorRGB,
                intensity: Float,
                influenceRadius: Float,
                castsShadows: Bool) {
        self.color = color
        self.intensity = intensity
        self.influenceRadius = influenceRadius
        self.castsShadows = castsShadows
        self.projectionMatrix = PNIOmniLight.projectionMatrix(influenceRadius: influenceRadius)
        self.projectionMatrixInverse = projectionMatrix.inverse
        self.boundingBox = PNIOmniLight.boundingBox(projectionMatrixInverse: projectionMatrixInverse)
    }
    private static func projectionMatrix(influenceRadius: Float) -> simd_float4x4 {
        simd_float4x4.perspectiveProjectionRightHand(fovyRadians: Float(90).radians,
                                                     aspect: 1,
                                                     nearZ: 0.01,
                                                     farZ: influenceRadius)
    }
    private static func boundingBox(projectionMatrixInverse: simd_float4x4) -> PNBoundingBox {
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

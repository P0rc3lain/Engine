//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIOmniLight: PNOmniLight {
    public let farPlane: Float
    public let nearPlane: Float
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
        assertValid(color: color)
        let nearPlance: Float = 0.01
        self.color = color
        self.intensity = intensity
        self.influenceRadius = influenceRadius
        self.castsShadows = castsShadows
        self.projectionMatrix = simd_float4x4.perspectiveProjectionRightHand(fovyRadians: Float(90).radians,
                                                                             aspect: 1,
                                                                             nearZ: nearPlance,
                                                                             farZ: influenceRadius)
        self.projectionMatrixInverse = projectionMatrix.inverse
        self.boundingBox = PNIOmniLight.boundingBox(projectionMatrixInverse: projectionMatrixInverse)
        self.nearPlane = nearPlance
        self.farPlane = influenceRadius
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

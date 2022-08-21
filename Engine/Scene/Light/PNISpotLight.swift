//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNISpotLight: PNSpotLight {
    public let color: PNColorRGB
    public let intensity: Float
    public let coneAngle: Radians
    public let castsShadows: Bool
    public let projectionMatrix: simd_float4x4
    public let projectionMatrixInverse: simd_float4x4
    public let boundingBox: PNBoundingBox
    public init(color: PNColorRGB,
                intensity: Float,
                coneAngle: Radians,
                castsShadows: Bool) {
        self.color = color
        self.intensity = intensity
        self.coneAngle = coneAngle
        self.castsShadows = castsShadows
        self.projectionMatrix = PNISpotLight.projectionMatrix(coneAngle: coneAngle)
        self.projectionMatrixInverse = projectionMatrix.inverse
        self.boundingBox = PNIBoundingBoxInteractor.default.from(inverseProjection: projectionMatrixInverse)
    }
    static func projectionMatrix(coneAngle: Radians) -> simd_float4x4 {
        simd_float4x4.perspectiveProjectionRightHand(fovyRadians: coneAngle,
                                                     aspect: 1,
                                                     nearZ: 0.01,
                                                     farZ: 1_000)
    }
}

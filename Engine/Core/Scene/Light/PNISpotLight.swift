//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNISpotLight: PNSpotLight {
    public let color: PNColorRGB
    public let intensity: Float
    public var influenceRadius: Float
    public let coneAngle: PNRadians
    public let innerConeAngle: PNRadians
    public let outerConeAngle: PNRadians
    public let castsShadows: Bool
    public let projectionMatrix: simd_float4x4
    public let projectionMatrixInverse: simd_float4x4
    public let boundingBox: PNBoundingBox
    public init(color: PNColorRGB,
                intensity: Float,
                influenceRadius: Float,
                coneAngle: PNRadians,
                innerConeAngle: PNRadians,
                outerConeAngle: PNRadians,
                castsShadows: Bool) {
        assertValid(color: color)
        self.color = color
        self.intensity = intensity
        self.influenceRadius = influenceRadius
        self.coneAngle = coneAngle
        self.innerConeAngle = innerConeAngle
        self.outerConeAngle = outerConeAngle
        self.castsShadows = castsShadows
        self.projectionMatrix = PNISpotLight.projectionMatrix(coneAngle: coneAngle,
                                                              influenceRadius: influenceRadius)
        self.projectionMatrixInverse = projectionMatrix.inverse
        self.boundingBox = PNIBoundingBoxInteractor.default.from(inverseProjection: projectionMatrixInverse)
    }
    static func projectionMatrix(coneAngle: PNRadians, influenceRadius: Float) -> simd_float4x4 {
        simd_float4x4.perspectiveProjectionRightHand(fovyRadians: coneAngle,
                                                     aspect: 1,
                                                     nearZ: 0.01,
                                                     farZ: influenceRadius)
    }
}

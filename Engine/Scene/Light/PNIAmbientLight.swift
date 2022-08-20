//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIAmbientLight: PNAmbientLight {
    public let diameter: Float
    public let color: PNColorRGB
    public let intensity: Float
    public let boundingBox: PNBoundingBox
    public init(diameter: Float,
                color: PNColorRGB,
                intensity: Float) {
        self.diameter = diameter
        self.color = color
        self.intensity = intensity
        self.boundingBox = PNIAmbientLight.boundingBox(diameter: diameter)
    }
    private static func boundingBox(diameter: Float) -> PNBoundingBox {
        let radius = diameter / 2
        let bound = PNBound(min: [-radius, -radius, -radius],
                            max: [radius, radius, radius])
        return PNIBoundingBoxInteractor.default.from(bound: bound)
    }
}

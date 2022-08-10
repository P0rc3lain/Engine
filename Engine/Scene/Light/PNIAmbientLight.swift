//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIAmbientLight: PNAmbientLight {
    public var diameter: Float
    public var color: PNColorRGB
    public var intensity: Float
    public init(diameter: Float,
                color: PNColorRGB,
                intensity: Float) {
        self.diameter = diameter
        self.color = color
        self.intensity = intensity
    }
}

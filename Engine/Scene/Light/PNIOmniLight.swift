//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public struct PNIOmniLight: PNOmniLight {
    public var color: PNColorRGB
    public var intensity: Float
    public init(color: PNColorRGB, intensity: Float) {
        self.color = color
        self.intensity = intensity
    }
}

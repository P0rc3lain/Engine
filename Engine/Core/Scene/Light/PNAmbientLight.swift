//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNAmbientLight {
    var diameter: Float { get }
    var color: PNColorRGB { get }
    var intensity: Float { get }
    var boundingBox: PNBoundingBox { get }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

public protocol PNDirectionalLight {
    var color: PNColorRGB { get }
    var intensity: Float { get }
    var direction: PNDirection3DN { get }
    var castsShadows: Bool { get }
}

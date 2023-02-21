//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd

/// Directional light simulates light that is being emitted from a source that is infinitely far away.
/// This means that all shadows cast by this light will be parallel, making this the ideal choice for simulating sunlight.
public protocol PNDirectionalLight {
    var color: PNColorRGB { get }
    var intensity: Float { get }
    var direction: PNDirection3DN { get }
    var castsShadows: Bool { get }
}

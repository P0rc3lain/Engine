//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

/// Describes whether or not each object on the screen is visible from different rendering sources.
/// When a model's bounding box is in sight the value becomes `true`, `false` otherwise.
public struct PNRenderMask {
    let cameras: [[Bool]]
    let spotLights: [[Bool]]
    let omniLights: [[Bool]]
    static var empty: PNRenderMask {
        PNRenderMask(cameras: [],
                     spotLights: [],
                     omniLights: [])
    }
}

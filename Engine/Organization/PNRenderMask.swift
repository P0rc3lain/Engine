//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

public struct PNRenderMask {
    let cameras: [[Bool]]
    let spotLights: [[Bool]]
    let omniLights: [[[Bool]]]
    static var empty: PNRenderMask {
        PNRenderMask(cameras: [],
                     spotLights: [],
                     omniLights: [])
    }
}

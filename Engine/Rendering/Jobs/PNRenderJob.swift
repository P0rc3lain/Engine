//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

public protocol PNRenderJob {
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply)
}

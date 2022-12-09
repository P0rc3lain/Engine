//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

protocol PNRenderJob {
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply)
}

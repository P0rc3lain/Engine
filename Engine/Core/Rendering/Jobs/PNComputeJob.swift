//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

protocol PNComputeJob {
    func compute(encoder: MTLComputeCommandEncoder, supply: PNFrameSupply)
}

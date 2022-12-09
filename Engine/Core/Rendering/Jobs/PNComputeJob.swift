//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal

public protocol PNComputeJob {
    func compute(encoder: MTLComputeCommandEncoder, supply: PNFrameSupply)
}

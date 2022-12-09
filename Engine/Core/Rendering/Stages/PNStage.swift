//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

protocol PNStage {
    var io: PNGPUIO { get }
    func draw(commandBuffer: MTLCommandBuffer, supply: PNFrameSupply)
}

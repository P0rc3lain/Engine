//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNGBufferJob {
    static func make(device: MTLDevice, drawableSize: CGSize) -> PNGBufferJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSGBuffer(library: library),
              let animatedPipelineState = device.makeRPSGBufferAnimated(library: library),
              let depthStencilState = device.makeDSSGBuffer() else {
            return nil
        }
        return PNGBufferJob(pipelineState: pipelineState,
                            animatedPipelineState: animatedPipelineState,
                            depthStencilState: depthStencilState,
                            drawableSize: drawableSize)
    }
}

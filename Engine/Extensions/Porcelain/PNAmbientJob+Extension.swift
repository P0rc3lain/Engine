//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNAmbientJob {
    static func make(device: MTLDevice, inputTextures: [MTLTexture], ssaoTexture: MTLTexture, drawableSize: CGSize) -> PNAmbientJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateAmbientRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateAmbientPass() else {
            return nil
        }
        return PNAmbientJob(pipelineState: pipelineState,
                            inputTextures: inputTextures,
                            ssaoTexture: ssaoTexture,
                            device: device,
                            depthStencilState: depthStencilState,
                            drawableSize: drawableSize)
    }
}

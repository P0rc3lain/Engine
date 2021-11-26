//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNSpotJob {
    static func make(device: MTLDevice,
                     inputTextures: [MTLTexture],
                     shadowMap: MTLTexture,
                     drawableSize: CGSize) -> PNSpotJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateSpotRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateSpotPass() else {
            return nil
        }
        return PNSpotJob(pipelineState: pipelineState,
                         inputTextures: inputTextures,
                         shadowMap: shadowMap,
                         device: device,
                         depthStencilState: depthStencilState,
                         drawableSize: drawableSize)
    }
}

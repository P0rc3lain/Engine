//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNOmniJob {
    static func make(device: MTLDevice,
                     inputTextures: [MTLTexture],
                     shadowMaps: MTLTexture,
                     drawableSize: CGSize) -> PNOmniJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateOmniRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateOmniPass() else {
            return nil
        }
        return PNOmniJob(pipelineState: pipelineState,
                         inputTextures: inputTextures,
                         shadowMaps: shadowMaps,
                         device: device,
                         depthStencilState: depthStencilState,
                         drawableSize: drawableSize)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension SpotRenderer {
    static func make(device: MTLDevice, inputTextures: [MTLTexture], drawableSize: CGSize) -> SpotRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateSpotRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateSpotPass() else {
            return nil
        }
        return SpotRenderer(pipelineState: pipelineState,
                            inputTextures: inputTextures,
                            device: device,
                            depthStencilState: depthStencilState,
                            drawableSize: drawableSize)
    }
}

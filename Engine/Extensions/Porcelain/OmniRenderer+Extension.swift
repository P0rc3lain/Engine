//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension OmniRenderer {
    static func make(device: MTLDevice, inputTextures: [MTLTexture], drawableSize: CGSize) -> OmniRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateOmniRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateOmniPass() else {
            return nil
        }
        return OmniRenderer(pipelineState: pipelineState,
                            inputTextures: inputTextures,
                            device: device,
                            depthStencilState: depthStencilState,
                            drawableSize: drawableSize)
    }
}

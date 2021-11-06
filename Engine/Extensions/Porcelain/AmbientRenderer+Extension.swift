//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension AmbientRenderer {
    static func make(device: MTLDevice, inputTextures: [MTLTexture], drawableSize: CGSize) -> AmbientRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateAmbientRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateAmbientPass() else {
            return nil
        }
        return AmbientRenderer(pipelineState: pipelineState,
                               inputTextures: inputTextures,
                               device: device,
                               depthStencilState: depthStencilState,
                               drawableSize: drawableSize)
    }
}

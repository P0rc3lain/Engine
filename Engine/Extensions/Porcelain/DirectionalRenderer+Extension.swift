//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension DirectionalRenderer {
    static func make(device: MTLDevice, inputTextures: [MTLTexture], drawableSize: CGSize) -> DirectionalRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateDirectionalRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateDirectionalPass() else {
            return nil
        }
        return DirectionalRenderer(pipelineState: pipelineState,
                                   inputTextures: inputTextures,
                                   device: device,
                                   depthStencilState: depthStencilState,
                                   drawableSize: drawableSize)
    }
}

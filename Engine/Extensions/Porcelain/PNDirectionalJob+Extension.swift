//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNDirectionalJob {
    static func make(device: MTLDevice,
                     inputTextures: [MTLTexture],
                     shadowMap: MTLTexture,
                     drawableSize: CGSize) -> PNDirectionalJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateDirectionalRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateDirectionalPass() else {
            return nil
        }
        return PNDirectionalJob(pipelineState: pipelineState,
                                inputTextures: inputTextures,
                                shadowMap: shadowMap,
                                device: device,
                                depthStencilState: depthStencilState,
                                drawableSize: drawableSize)
    }
}

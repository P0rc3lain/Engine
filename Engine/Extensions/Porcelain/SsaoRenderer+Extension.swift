//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension SsaoRenderer {
    static func make(device: MTLDevice, prTexture: MTLTexture, nmTexture: MTLTexture, drawableSize: CGSize) -> SsaoRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateSsao(library: library) else {
            return nil
        }
        return SsaoRenderer(pipelineState: pipelineState,
                            prTexture: prTexture,
                            nmTexture: nmTexture,
                            device: device,
                            drawableSize: drawableSize)
    }
}

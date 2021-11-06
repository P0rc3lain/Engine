//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension BloomSplitRenderer {
    static func make(device: MTLDevice,
                     inputTexture: MTLTexture,
                     drawableSize: CGSize) -> BloomSplitRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateBloomSplit(library: library) else {
            return nil
        }
        return BloomSplitRenderer(pipelineState: pipelineState,
                                  inputTexture: inputTexture,
                                  device: device,
                                  drawableSize: drawableSize)
    }
}

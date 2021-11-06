//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension BloomMergeRenderer {
    static func make(device: MTLDevice,
                     drawableSize: CGSize) -> BloomMergeRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateBloomMerge(library: library) else {
            return nil
        }
        return BloomMergeRenderer(pipelineState: pipelineState,
                                  device: device,
                                  drawableSize: drawableSize)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNBloomSplitJob {
    static func make(device: MTLDevice,
                     inputTexture: MTLTexture,
                     drawableSize: CGSize) -> PNBloomSplitJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateBloomSplit(library: library) else {
            return nil
        }
        return PNBloomSplitJob(pipelineState: pipelineState,
                               inputTexture: inputTexture,
                               device: device,
                               drawableSize: drawableSize)
    }
}

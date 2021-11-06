//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension BloomSplitRenderer {
    static func make(device: MTLDevice,
                     inputRenderPassDescriptor: MTLRenderPassDescriptor,
                     drawableSize: CGSize) -> BloomSplitRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateBloomSplit(library: library) else {
            return nil
        }
        return BloomSplitRenderer(pipelineState: pipelineState,
                             inputRenderPass: inputRenderPassDescriptor,
                             device: device,
                             drawableSize: drawableSize)
    }
}

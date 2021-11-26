//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNBloomMergeJob {
    static func make(device: MTLDevice,
                     drawableSize: CGSize,
                     unmodifiedSceneTexture: MTLTexture,
                     brightAreasTexture: MTLTexture) -> PNBloomMergeJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateBloomMerge(library: library) else {
            return nil
        }
        return PNBloomMergeJob(pipelineState: pipelineState,
                               device: device,
                               unmodifiedSceneTexture: unmodifiedSceneTexture,
                               brightAreasTexture: brightAreasTexture,
                               drawableSize: drawableSize)
    }
}

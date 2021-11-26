//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNVignetteJob {
    static func make(device: MTLDevice,
                     inputTexture: MTLTexture,
                     canvasSize: CGSize) -> PNVignetteJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateVignette(library: library),
              let plane = PNMesh.screenSpacePlane(device: device) else {
            return nil
        }
        return PNVignetteJob(pipelineState: pipelineState,
                             inputTexture: inputTexture,
                             plane: plane,
                             canvasSize: canvasSize)
    }
}

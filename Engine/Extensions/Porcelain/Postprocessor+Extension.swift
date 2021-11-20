//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension Postprocessor {
    static func make(device: MTLDevice,
                     inputTexture: MTLTexture,
                     canvasSize: CGSize) -> Postprocessor? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStatePostprocessor(library: library),
              let plane = PNGPUMesh.screenSpacePlane(device: device) else {
            return nil
        }
        return Postprocessor(pipelineState: pipelineState,
                             inputTexture: inputTexture,
                             plane: plane,
                             canvasSize: canvasSize)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNEnvironmentJob {
    static func make(device: MTLDevice, drawableSize: CGSize) -> PNEnvironmentJob? {
        guard let library = device.makePorcelainLibrary(),
              let environmentPipelineState = device.makeRenderPipelineStateEnvironmentRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateEnvironmentRenderer(),
              let cube = PNMesh.cube(device: device) else {
            return nil
        }
        return PNEnvironmentJob(pipelineState: environmentPipelineState,
                                depthStentilState: depthStencilState,
                                drawableSize: drawableSize,
                                cube: cube)
    }
}

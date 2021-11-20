//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension EnvironmentRenderer {
    static func make(device: MTLDevice, drawableSize: CGSize) -> EnvironmentRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let environmentPipelineState = device.makeRenderPipelineStateEnvironmentRenderer(library: library),
              let depthStencilState = device.makeDepthStencilStateEnvironmentRenderer(),
              let cube = PNMesh.cube(device: device) else {
            return nil
        }
        return EnvironmentRenderer(pipelineState: environmentPipelineState,
                                   depthStentilState: depthStencilState,
                                   drawableSize: drawableSize,
                                   cube: cube)
    }
}

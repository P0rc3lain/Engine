//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension EnvironmentRenderer {
    static func make(device: MTLDevice, drawableSize: CGSize) -> EnvironmentRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let environmentPipelineState = device.makeRenderPipelineStateEnvironmentRenderer(library: library) else {
            return nil
        }
        let depthStencilState = device.makeDepthStencilStateEnvironmentRenderer()
        let cube = Geometry.cube(device: device)
        return EnvironmentRenderer(pipelineState: environmentPipelineState,
                                   depthStentilState: depthStencilState,
                                   drawableSize: drawableSize,
                                   cube: cube)
    }
}

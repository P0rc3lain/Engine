//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension SpotShadowRenderer {
    static func make(device: MTLDevice,
                     renderingSize: CGSize) -> SpotShadowRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateSpotLightShadow(library: library),
              let depthStencilState = device.makeDepthStencilStateSpotLightShadowRenderer(),
              let animatedPipelineState = device.makeRenderPipelineStateSpotLightShadowAnimated(library: library) else {
            return nil
        }
        return SpotShadowRenderer(pipelineState: pipelineState,
                                  animatedPipelineState: animatedPipelineState,
                                  depthStencilState: depthStencilState,
                                  viewPort: .porcelain(size: renderingSize))
    }
}

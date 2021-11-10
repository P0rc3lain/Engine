//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension OmniShadowRenderer {
    static func make(device: MTLDevice,
                     renderingSize: CGSize) -> OmniShadowRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateOmniLightShadow(library: library),
              let depthStencilState = device.makeDepthStencilStateOmniLightShadowRenderer(),
              let animatedPipelineState = device.makeRenderPipelineStateOmniLightShadowAnimated(library: library) else {
            return nil
        }
        return OmniShadowRenderer(pipelineState: pipelineState,
                                  animatedPipelineState: animatedPipelineState,
                                  depthStencilState: depthStencilState,
                                  viewPort: .porcelain(size: renderingSize))
    }
}

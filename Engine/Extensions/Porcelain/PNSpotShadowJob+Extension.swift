//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal

extension PNSpotShadowJob {
    static func make(device: MTLDevice,
                     renderingSize: CGSize) -> PNSpotShadowJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateSpotLightShadow(library: library),
              let depthStencilState = device.makeDepthStencilStateSpotLightShadowRenderer(),
              let animatedPipelineState = device.makeRenderPipelineStateSpotLightShadowAnimated(library: library) else {
            return nil
        }
        return PNSpotShadowJob(pipelineState: pipelineState,
                               animatedPipelineState: animatedPipelineState,
                               depthStencilState: depthStencilState,
                               viewPort: .porcelain(size: renderingSize))
    }
}

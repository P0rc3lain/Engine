//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

extension PNDirectionalShadowJob {
    static func make(device: MTLDevice,
                     renderingSize: CGSize) -> PNDirectionalShadowJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateDirectionalLightShadow(library: library),
              let depthStencilState = device.makeDepthStencilStateDirectionalLightShadowRenderer(),
              let animatedPipelineState = device.makeRenderPipelineStateDirectionalLightShadowAnimated(library: library) else {
            return nil
        }
        return PNDirectionalShadowJob(pipelineState: pipelineState,
                                      animatedPipelineState: animatedPipelineState,
                                      depthStencilState: depthStencilState,
                                      viewPort: .porcelain(size: renderingSize))
    }
}

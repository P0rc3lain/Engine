//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

extension OmniShadowRenderer {
    static func make(device: MTLDevice,
                     renderingSize: CGSize) -> OmniShadowRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateOmniLightShadow(library: library),
              let depthStencilState = device.makeDepthStencilStateOmniLightShadowRenderer(),
              let animatedPipelineState = device.makeRenderPipelineStateOmniLightShadowAnimated(library: library),
              let rotationsBuffer = StaticBuffer<simd_float4x4>(device: device, capacity: 6) else {
            return nil
        }
        return OmniShadowRenderer(pipelineState: pipelineState,
                                  animatedPipelineState: animatedPipelineState,
                                  depthStencilState: depthStencilState,
                                  rotationsBuffer: rotationsBuffer,
                                  viewPort: .porcelain(size: renderingSize))
    }
}

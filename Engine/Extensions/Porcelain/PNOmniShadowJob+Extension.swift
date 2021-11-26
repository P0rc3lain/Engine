//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

extension PNOmniShadowJob {
    static func make(device: MTLDevice,
                     renderingSize: CGSize) -> PNOmniShadowJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateOmniLightShadow(library: library),
              let depthStencilState = device.makeDepthStencilStateOmniLightShadowRenderer(),
              let animatedPipelineState = device.makeRenderPipelineStateOmniLightShadowAnimated(library: library),
              let rotationsBuffer = PNIStaticBuffer<simd_float4x4>(device: device, capacity: 6) else {
            return nil
        }
        return PNOmniShadowJob(pipelineState: pipelineState,
                               animatedPipelineState: animatedPipelineState,
                               depthStencilState: depthStencilState,
                               rotationsBuffer: PNAnyStaticBuffer(rotationsBuffer),
                               viewPort: .porcelain(size: renderingSize))
    }
}

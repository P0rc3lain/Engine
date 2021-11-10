//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import simd

extension SsaoRenderer {
    static func make(device: MTLDevice, prTexture: MTLTexture, nmTexture: MTLTexture, drawableSize: CGSize) -> SsaoRenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateSsao(library: library),
              let kernelBuffer = StaticBuffer<simd_float3>(device: device, capacity: 64),
              let noiseBuffer = StaticBuffer<simd_float3>(device: device, capacity: 16) else {
            return nil
        }
        return SsaoRenderer(pipelineState: pipelineState,
                            prTexture: prTexture,
                            nmTexture: nmTexture,
                            device: device,
                            drawableSize: drawableSize,
                            kernelBuffer: kernelBuffer,
                            noiseBuffer: noiseBuffer)
    }
}

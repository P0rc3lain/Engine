//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

extension SSAORenderer {
    static func make(device: MTLDevice,
                     prTexture: MTLTexture,
                     nmTexture: MTLTexture,
                     drawableSize: CGSize,
                     maxNoiseCount: Int,
                     maxSamplesCount: Int) -> SSAORenderer? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRenderPipelineStateSsao(library: library),
              let kernelBuffer = PNIStaticBuffer<simd_float3>(device: device, capacity: 64),
              let noiseBuffer = PNIStaticBuffer<simd_float3>(device: device, capacity: 16),
              let uniforms = PNIStaticBuffer<SSAOUniforms>(device: device, capacity: 1)
        else {
            return nil
        }
        return SSAORenderer(pipelineState: pipelineState,
                            prTexture: prTexture,
                            nmTexture: nmTexture,
                            device: device,
                            drawableSize: drawableSize,
                            kernelBuffer: PNAnyStaticBuffer(kernelBuffer),
                            noiseBuffer: PNAnyStaticBuffer(noiseBuffer),
                            uniforms: PNAnyStaticBuffer(uniforms),
                            maxNoiseCount: maxNoiseCount,
                            maxSamplesCount: maxSamplesCount)
    }
}

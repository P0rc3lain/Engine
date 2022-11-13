//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNSSAOJob: PNComputeJob {
    private let pipelineState: MTLComputePipelineState
    private let prTexture: PNTextureProvider
    private let nmTexture: PNTextureProvider
    private let outputTexture: PNTextureProvider
    private var kernelBuffer: PNAnyStaticBuffer<simd_float3>
    private var noiseBuffer: PNAnyStaticBuffer<simd_float3>
    private var uniforms: PNAnyStaticBuffer<SSAOUniforms>
    private let dispatchSize: MTLSize
    private let threadGroupSize: MTLSize
    init?(pipelineState: MTLComputePipelineState,
          prTexture: PNTextureProvider,
          nmTexture: PNTextureProvider,
          outputTexture: PNTextureProvider,
          kernelBuffer: PNAnyStaticBuffer<simd_float3>,
          noiseBuffer: PNAnyStaticBuffer<simd_float3>,
          uniforms: PNAnyStaticBuffer<SSAOUniforms>,
          maxNoiseCount: Int,
          maxSamplesCount: Int) {
        self.pipelineState = pipelineState
        self.nmTexture = nmTexture
        self.outputTexture = outputTexture
        self.prTexture = prTexture
        self.kernelBuffer = kernelBuffer
        self.noiseBuffer = noiseBuffer
        self.uniforms = uniforms
        self.kernelBuffer.upload(data: PNISSAOHemisphere().samples(size: maxSamplesCount))
        self.noiseBuffer.upload(data: PNISSAOHemisphere().noise(count: maxNoiseCount))
        self.uniforms.upload(value: .default)
        guard let inputTexture = prTexture.texture else {
            return nil
        }
        dispatchSize = MTLSize(width: inputTexture.width,
                               height: inputTexture.height)
        threadGroupSize = MTLSize(width: 8, height: 8)
    }
    func compute(encoder: MTLComputeCommandEncoder, supply: PNFrameSupply) {
        encoder.setComputePipelineState(pipelineState)
        encoder.setBuffer(kernelBuffer, index: kAttributeSsaoComputeShaderBufferSamples)
        encoder.setBuffer(supply.bufferStore.modelCoordinateSystems, index: kAttributeSsaoComputeShaderBufferModelUniforms)
        encoder.setBuffer(noiseBuffer, index: kAttributeSsaoComputeShaderBufferNoise)
        encoder.setBuffer(supply.bufferStore.cameras, index: kAttributeSsaoComputeShaderBufferCamera)
        encoder.setBuffer(uniforms, index: kAttributeSsaoComputeShaderBufferRenderingUniforms)
        encoder.setTexture(nmTexture, index: kAttributeSsaoComputeShaderTextureNM)
        encoder.setTexture(prTexture, index: kAttributeSsaoComputeShaderTexturePR)
        encoder.setTexture(outputTexture, index: kAttributeSsaoComputeShaderTextureOutput)
        encoder.dispatchThreads(dispatchSize, threadsPerThreadgroup: threadGroupSize)
    }
    static func make(device: MTLDevice,
                     prTexture: PNTextureProvider,
                     nmTexture: PNTextureProvider,
                     outputTexture: PNTextureProvider,
                     maxNoiseCount: Int,
                     maxSamplesCount: Int) -> PNSSAOJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeCPSSSAO(library: library),
              let kernelBuffer = PNIStaticBuffer<simd_float3>(device: device, capacity: 64),
              let noiseBuffer = PNIStaticBuffer<simd_float3>(device: device, capacity: 64),
              let uniforms = PNIStaticBuffer<SSAOUniforms>(device: device, capacity: 1)
        else {
            return nil
        }
        return PNSSAOJob(pipelineState: pipelineState,
                         prTexture: prTexture,
                         nmTexture: nmTexture,
                         outputTexture: outputTexture,
                         kernelBuffer: PNAnyStaticBuffer(kernelBuffer),
                         noiseBuffer: PNAnyStaticBuffer(noiseBuffer),
                         uniforms: PNAnyStaticBuffer(uniforms),
                         maxNoiseCount: maxNoiseCount,
                         maxSamplesCount: maxSamplesCount)
    }
}

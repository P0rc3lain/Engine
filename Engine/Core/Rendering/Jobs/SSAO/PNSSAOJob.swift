//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import simd

struct PNSSAOJob: PNComputeJob {
    private let pipelineState: MTLComputePipelineState
    private let prTexture: PNTextureProvider
    private let nmTexture: PNTextureProvider
    private let outputTexture: PNTextureProvider
    private var kernelBuffer: PNAnyDynamicBuffer<simd_float3>
    private var noiseBuffer: PNAnyDynamicBuffer<simd_float3>
    private let dispatchSize: MTLSize
    init?(pipelineState: MTLComputePipelineState,
          prTexture: PNTextureProvider,
          nmTexture: PNTextureProvider,
          outputTexture: PNTextureProvider,
          kernelBuffer: PNAnyDynamicBuffer<simd_float3>,
          noiseBuffer: PNAnyDynamicBuffer<simd_float3>) {
        // Default values
        let ssaoConstants = PNDefaults.shared.shaders.ssao
        let ssaoHemisphere = PNISSAOHemisphere()
        let samples = ssaoHemisphere.samples(size: ssaoConstants.sampleCount,
                                             radius: ssaoConstants.radius)
        let noise = ssaoHemisphere.noise(count: ssaoConstants.noiseCount)
        self.pipelineState = pipelineState
        self.nmTexture = nmTexture
        self.outputTexture = outputTexture
        self.prTexture = prTexture
        self.kernelBuffer = kernelBuffer
        self.noiseBuffer = noiseBuffer
        self.kernelBuffer.upload(data: samples)
        self.noiseBuffer.upload(data: noise)
        guard let outputTexture = outputTexture.texture else {
            return nil
        }
        dispatchSize = MTLSize(width: outputTexture.width,
                               height: outputTexture.height)
    }
    func compute(encoder: MTLComputeCommandEncoder, supply: PNFrameSupply) {
        let time = Int32(Date.timeIntervalSinceReferenceDate)
        encoder.setComputePipelineState(pipelineState)
        encoder.setBuffer(kernelBuffer, index: kAttributeSsaoComputeShaderBufferSamples)
        encoder.setBuffer(supply.bufferStore.modelCoordinateSystems, index: kAttributeSsaoComputeShaderBufferModelUniforms)
        encoder.setBuffer(noiseBuffer, index: kAttributeSsaoComputeShaderBufferNoise)
        encoder.setBuffer(supply.bufferStore.cameras, index: kAttributeSsaoComputeShaderBufferCamera)
        encoder.setBytes(time, index: kAttributeSsaoComputeShaderBufferTime)
        encoder.setTexture(nmTexture, index: kAttributeSsaoComputeShaderTextureNM)
        encoder.setTexture(prTexture, index: kAttributeSsaoComputeShaderTexturePR)
        encoder.setTexture(outputTexture, index: kAttributeSsaoComputeShaderTextureOutput)
        encoder.dispatchThreads(dispatchSize,
                                threadsPerThreadgroup: pipelineState.suggestedThreadGroupSize)
    }
    static func make(device: MTLDevice,
                     prTexture: PNTextureProvider,
                     nmTexture: PNTextureProvider,
                     outputTexture: PNTextureProvider) -> PNSSAOJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeCPSSSAO(library: library)
        guard let kernelBuffer = PNIDynamicBuffer<simd_float3>(device: device, initialCapacity: 1),
              let noiseBuffer = PNIDynamicBuffer<simd_float3>(device: device, initialCapacity: 1)
        else {
            return nil
        }
        return PNSSAOJob(pipelineState: pipelineState,
                         prTexture: prTexture,
                         nmTexture: nmTexture,
                         outputTexture: outputTexture,
                         kernelBuffer: PNAnyDynamicBuffer(kernelBuffer),
                         noiseBuffer: PNAnyDynamicBuffer(noiseBuffer))
    }
}

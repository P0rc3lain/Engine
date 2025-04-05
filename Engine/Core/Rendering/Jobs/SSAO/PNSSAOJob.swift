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
    private var uniforms: PNAnyStaticBuffer<SSAOUniforms>
    private let dispatchSize: MTLSize
    private let threadGroupSize: MTLSize
    init?(pipelineState: MTLComputePipelineState,
          prTexture: PNTextureProvider,
          nmTexture: PNTextureProvider,
          outputTexture: PNTextureProvider,
          kernelBuffer: PNAnyDynamicBuffer<simd_float3>,
          noiseBuffer: PNAnyDynamicBuffer<simd_float3>,
          uniforms: PNAnyStaticBuffer<SSAOUniforms>) {
        // Default values
        let ssaoUniforms = SSAOUniforms.default
        let samples = PNISSAOHemisphere().samples(size: Int(ssaoUniforms.sampleCount))
        let noise = PNISSAOHemisphere().noise(count: Int(ssaoUniforms.noiseCount))
        self.pipelineState = pipelineState
        self.nmTexture = nmTexture
        self.outputTexture = outputTexture
        self.prTexture = prTexture
        self.kernelBuffer = kernelBuffer
        self.noiseBuffer = noiseBuffer
        self.uniforms = uniforms
        self.kernelBuffer.upload(data: samples)
        self.noiseBuffer.upload(data: noise)
        self.uniforms.upload(value: ssaoUniforms)
        guard let inputTexture = prTexture.texture else {
            return nil
        }
        dispatchSize = MTLSize(width: inputTexture.width,
                               height: inputTexture.height)
        // TODO: Rescale
        let sideThreadGroup = 4
        assertDivisible(inputTexture.width, sideThreadGroup)
        assertDivisible(inputTexture.height, sideThreadGroup)
        threadGroupSize = MTLSize(width: sideThreadGroup, height: sideThreadGroup)
    }
    func compute(encoder: MTLComputeCommandEncoder, supply: PNFrameSupply) {
        let time = Int32(Date.timeIntervalSinceReferenceDate)
        encoder.setComputePipelineState(pipelineState)
        encoder.setBuffer(kernelBuffer, index: kAttributeSsaoComputeShaderBufferSamples)
        encoder.setBuffer(supply.bufferStore.modelCoordinateSystems, index: kAttributeSsaoComputeShaderBufferModelUniforms)
        encoder.setBuffer(noiseBuffer, index: kAttributeSsaoComputeShaderBufferNoise)
        encoder.setBuffer(supply.bufferStore.cameras, index: kAttributeSsaoComputeShaderBufferCamera)
        encoder.setBuffer(uniforms, index: kAttributeSsaoComputeShaderBufferRenderingUniforms)
        encoder.setBytes(time, index: kAttributeSsaoComputeShaderBufferTime)
        encoder.setTexture(nmTexture, index: kAttributeSsaoComputeShaderTextureNM)
        encoder.setTexture(prTexture, index: kAttributeSsaoComputeShaderTexturePR)
        encoder.setTexture(outputTexture, index: kAttributeSsaoComputeShaderTextureOutput)
        encoder.dispatchThreads(dispatchSize, threadsPerThreadgroup: threadGroupSize)
    }
    static func make(device: MTLDevice,
                     prTexture: PNTextureProvider,
                     nmTexture: PNTextureProvider,
                     outputTexture: PNTextureProvider) -> PNSSAOJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeCPSSSAO(library: library)
        guard let kernelBuffer = PNIDynamicBuffer<simd_float3>(device: device, initialCapacity: 1),
              let noiseBuffer = PNIDynamicBuffer<simd_float3>(device: device, initialCapacity: 1),
              let uniforms = PNIStaticBuffer<SSAOUniforms>(device: device, capacity: 1)
        else {
            return nil
        }
        return PNSSAOJob(pipelineState: pipelineState,
                         prTexture: prTexture,
                         nmTexture: nmTexture,
                         outputTexture: outputTexture,
                         kernelBuffer: PNAnyDynamicBuffer(kernelBuffer),
                         noiseBuffer: PNAnyDynamicBuffer(noiseBuffer),
                         uniforms: PNAnyStaticBuffer(uniforms))
    }
}

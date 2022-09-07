//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNSSAOJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let plane: PNMesh
    private let prTexture: PNTextureProvider
    private let nmTexture: PNTextureProvider
    private var kernelBuffer: PNAnyStaticBuffer<simd_float3>
    private var noiseBuffer: PNAnyStaticBuffer<simd_float3>
    private var uniforms: PNAnyStaticBuffer<SSAOUniforms>
    init?(pipelineState: MTLRenderPipelineState,
          prTexture: PNTextureProvider,
          nmTexture: PNTextureProvider,
          device: MTLDevice,
          kernelBuffer: PNAnyStaticBuffer<simd_float3>,
          noiseBuffer: PNAnyStaticBuffer<simd_float3>,
          uniforms: PNAnyStaticBuffer<SSAOUniforms>,
          maxNoiseCount: Int,
          maxSamplesCount: Int) {
        guard let plane = PNMesh.plane(device: device) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.nmTexture = nmTexture
        self.prTexture = prTexture
        self.plane = plane
        self.kernelBuffer = kernelBuffer
        self.noiseBuffer = noiseBuffer
        self.uniforms = uniforms
        self.kernelBuffer.upload(data: PNISSAOHemisphere().samples(size: maxSamplesCount))
        self.noiseBuffer.upload(data: PNISSAOHemisphere().noise(count: maxNoiseCount))
        self.uniforms.upload(value: .default)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let bufferStore = supply.bufferStore
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeSsaoVertexShaderBufferStageIn)
        encoder.setFragmentBuffer(kernelBuffer.buffer,
                                  index: kAttributeSsaoFragmentShaderBufferSamples)
        encoder.setFragmentBuffer(bufferStore.modelCoordinateSystems,
                                  index: kAttributeSsaoFragmentShaderBufferModelUniforms)
        encoder.setFragmentBuffer(noiseBuffer.buffer,
                                  index: kAttributeSsaoFragmentShaderBufferNoise)
        encoder.setFragmentBuffer(bufferStore.cameras,
                                  index: kAttributeSsaoFragmentShaderBufferCamera)
        encoder.setFragmentBuffer(uniforms.buffer,
                                  index: kAttributeSsaoFragmentShaderBufferRenderingUniforms)
        let range = kAttributeSsaoFragmentShaderTextureNM ... kAttributeSsaoFragmentShaderTexturePR
        encoder.setFragmentTextures([nmTexture, prTexture],
                                    range: range)
        encoder.drawIndexedPrimitives(submesh: plane.pieceDescriptions[0].drawDescription)
    }
    static func make(device: MTLDevice,
                     prTexture: PNTextureProvider,
                     nmTexture: PNTextureProvider,
                     maxNoiseCount: Int,
                     maxSamplesCount: Int) -> PNSSAOJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSSSAO(library: library),
              let kernelBuffer = PNIStaticBuffer<simd_float3>(device: device, capacity: 64),
              let noiseBuffer = PNIStaticBuffer<simd_float3>(device: device, capacity: 64),
              let uniforms = PNIStaticBuffer<SSAOUniforms>(device: device, capacity: 1)
        else {
            return nil
        }
        return PNSSAOJob(pipelineState: pipelineState,
                         prTexture: prTexture,
                         nmTexture: nmTexture,
                         device: device,
                         kernelBuffer: PNAnyStaticBuffer(kernelBuffer),
                         noiseBuffer: PNAnyStaticBuffer(noiseBuffer),
                         uniforms: PNAnyStaticBuffer(uniforms),
                         maxNoiseCount: maxNoiseCount,
                         maxSamplesCount: maxSamplesCount)
    }
}

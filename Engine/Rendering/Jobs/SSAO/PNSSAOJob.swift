//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNSSAOJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let viewPort: MTLViewport
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
          drawableSize: CGSize,
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
        self.viewPort = .porcelain(size: drawableSize)
        self.kernelBuffer = kernelBuffer
        self.noiseBuffer = noiseBuffer
        self.uniforms = uniforms
        var kernel = PNISSAOHemisphere().samples(size: maxSamplesCount)
        var noise = PNISSAOHemisphere().noise(count: maxNoiseCount)
        var uniforms = SSAOUniforms.default
        self.kernelBuffer.upload(data: &kernel)
        self.noiseBuffer.upload(data: &noise)
        self.uniforms.upload(value: &uniforms)
    }
    private mutating func updateUniforms(_ uniforms: inout SSAOUniforms) {
        self.uniforms.upload(value: &uniforms)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let bufferStore = supply.bufferStore
        encoder.setViewport(viewPort)
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
                     drawableSize: CGSize,
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
                         drawableSize: drawableSize,
                         kernelBuffer: PNAnyStaticBuffer(kernelBuffer),
                         noiseBuffer: PNAnyStaticBuffer(noiseBuffer),
                         uniforms: PNAnyStaticBuffer(uniforms),
                         maxNoiseCount: maxNoiseCount,
                         maxSamplesCount: maxSamplesCount)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct SsaoRenderer {
    private let pipelineState: MTLRenderPipelineState
    private let viewPort: MTLViewport
    private let plane: GPUGeometry
    private let prTexture: MTLTexture
    private let nmTexture: MTLTexture
    private var kernelBuffer: StaticBuffer<simd_float3>
    private var noiseBuffer: StaticBuffer<simd_float3>
    init?(pipelineState: MTLRenderPipelineState,
          prTexture: MTLTexture,
          nmTexture: MTLTexture,
          device: MTLDevice,
          drawableSize: CGSize,
          kernelBuffer: StaticBuffer<simd_float3>,
          noiseBuffer: StaticBuffer<simd_float3>) {
        guard let plane = GPUGeometry.screenSpacePlane(device: device) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.nmTexture = nmTexture
        self.prTexture = prTexture
        self.plane = plane
        self.viewPort = .porcelain(size: drawableSize)
        self.kernelBuffer = kernelBuffer
        self.noiseBuffer = noiseBuffer
        var kernel = generateSamples(size: 64)
        var noise = generateNoise()
        self.kernelBuffer.upload(data: &kernel)
        self.noiseBuffer.upload(data: &noise)
    }
    mutating func draw(encoder: inout MTLRenderCommandEncoder, bufferStore: inout BufferStore) {
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
        let range = kAttributeSsaoFragmentShaderTextureNM ... kAttributeSsaoFragmentShaderTexturePR
        encoder.setFragmentTextures([nmTexture, prTexture],
                                    range: range)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset)
    }
    private func generateNoise() -> [simd_float3] {
        var samples = [simd_float3]()
        for _ in 16.naturalExclusive {
            samples.append(simd_float3(Float.random(in: 0 ..< 1) * 2 - 1,
                                       Float.random(in: 0 ..< 1) * 2 - 1,
                                       0))
        }
        return samples
    }
    private func generateSamples(size: Int) -> [simd_float3] {
        var samples = [simd_float3]()
        for index in 0 ..< size {
            var vector = normalize(simd_float3(Float.random(in: 0 ..< 1) * 2 - 1,
                                               Float.random(in: 0 ..< 1) * 2 - 1,
                                               Float.random(in: 0 ..< 1)))
            vector *= Float.random(in: 0 ..< 1)
            let scale = Float(index / size)
            let scaleFactor = simd_mix(0.1, 1.0, scale * scale)
            vector *= scaleFactor
            samples.append(vector)
        }
        return samples
    }
}

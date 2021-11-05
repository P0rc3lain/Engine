//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct SsaoRenderer {
    private let pipelineState: MTLRenderPipelineState
    private let viewPort: MTLViewport
    private let gBufferRenderPassDescriptor: MTLRenderPassDescriptor
    private let plane: GPUGeometry
    private var kernel = [simd_float3]()
    private var noise = [simd_float3]()
    init?(pipelineState: MTLRenderPipelineState,
          gBufferRenderPassDescriptor: MTLRenderPassDescriptor,
          device: MTLDevice,
          drawableSize: CGSize) {
        guard let plane = GPUGeometry.screenSpacePlane(device: device) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.gBufferRenderPassDescriptor = gBufferRenderPassDescriptor
        self.plane = plane
        self.viewPort = .porcelain(size: drawableSize)
        self.kernel = generateSamples(size: 64)
        self.noise = generateNoise()
    }
    mutating func draw(encoder: inout MTLRenderCommandEncoder, bufferStore: inout BufferStore) {
        guard let nmTexture = gBufferRenderPassDescriptor.colorAttachments[1].texture,
              let prTexture = gBufferRenderPassDescriptor.colorAttachments[2].texture else {
            fatalError("Required textures not bound")
        }
        bufferStore.ssaoKernel.upload(data: &kernel)
        bufferStore.ssaoNoise.upload(data: &noise)
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeSsaoVertexShaderBufferStageIn)
        encoder.setFragmentBuffer(bufferStore.ssaoKernel.buffer,
                                  index: kAttributeSsaoFragmentShaderBufferSamples)
        encoder.setFragmentBuffer(bufferStore.modelCoordinateSystems.buffer,
                                  index: kAttributeSsaoFragmentShaderBufferModelUniforms)
        encoder.setFragmentBuffer(bufferStore.ssaoNoise.buffer,
                                  index: kAttributeSsaoFragmentShaderBufferNoise)
        encoder.setFragmentBuffer(bufferStore.cameras.buffer,
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
    func generateNoise() -> [simd_float3] {
        var samples = [simd_float3]()
        for _ in 16.naturalExclusive {
            samples.append(simd_float3(Float.random(in: 0 ..< 1) * 2 - 1,
                                       Float.random(in: 0 ..< 1) * 2 - 1,
                                       0))
        }
        return samples
    }
    func generateSamples(size: Int) -> [simd_float3] {
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

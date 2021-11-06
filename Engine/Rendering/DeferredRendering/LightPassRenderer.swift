//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import MetalKit
import simd

struct LightPassRenderer {
    let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    private let gbufferRenderPass: MTLRenderPassDescriptor
    private let plane: GPUGeometry
    init?(pipelineState: MTLRenderPipelineState,
          gBufferRenderPass: MTLRenderPassDescriptor,
          device: MTLDevice,
          depthStencilState: MTLDepthStencilState,
          drawableSize: CGSize) {
        guard let plane = GPUGeometry.screenSpacePlane(device: device) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.gbufferRenderPass = gBufferRenderPass
        self.plane = plane
        self.viewPort = .porcelain(size: drawableSize)
    }
    func draw(encoder: inout MTLRenderCommandEncoder,
              bufferStore: inout BufferStore,
              lightsCount: Int,
              ssao: MTLTexture) {
        guard let arTexture = gbufferRenderPass.colorAttachments[0].texture,
              let nmTexture = gbufferRenderPass.colorAttachments[1].texture,
              let prTexture = gbufferRenderPass.colorAttachments[2].texture else {
            fatalError("Required textures not bound")
        }
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeLightingVertexShaderBufferStageIn)
        encoder.setFragmentBuffer(bufferStore.omniLights.buffer,
                                  index: kAttributeLightingFragmentShaderBufferOmniLights)
        encoder.setFragmentBuffer(bufferStore.cameras.buffer,
                                  index: kAttributeLightingFragmentShaderBufferCamera)
        encoder.setFragmentBuffer(bufferStore.modelCoordinateSystems.buffer,
                                  index: kAttributeLightingFragmentShaderBufferLightUniforms)
        let range = kAttributeLightingFragmentShaderTextureAR ... kAttributeLightingFragmentShaderTextureSSAO
        encoder.setFragmentTextures([arTexture, nmTexture, prTexture, ssao], range: range)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset,
                                      instanceCount: lightsCount)
    }
}

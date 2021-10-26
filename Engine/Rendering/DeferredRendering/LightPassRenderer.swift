//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import MetalKit
import simd

struct LightPassRenderer {
    // MARK: - Properties
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    private let gbufferRenderPass: MTLRenderPassDescriptor
    private let plane: GPUGeometry
    // MARK: - Initialization
    init(pipelineState: MTLRenderPipelineState, gBufferRenderPass: MTLRenderPassDescriptor, device: MTLDevice, depthStencilState: MTLDepthStencilState, drawableSize: CGSize) {
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.gbufferRenderPass = gBufferRenderPass
        self.plane = GPUGeometry.screenSpacePlane(device: device)
        self.viewPort = .porcelain(size: drawableSize)
    }
    // MARK: - Internal
    func draw(encoder: inout MTLRenderCommandEncoder, bufferStore: inout BufferStore, lightsCount: Int) {
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeLightingVertexShaderBufferStageIn.int)
        encoder.setFragmentBuffer(bufferStore.omniLights.buffer,
                                  index: kAttributeLightingFragmentShaderBufferOmniLights.int)
        encoder.setFragmentBuffer(bufferStore.cameras.buffer,
                                  index: kAttributeLightingFragmentShaderBufferCamera.int)
        encoder.setFragmentBuffer(bufferStore.modelCoordinateSystems.buffer,
                                  index: kAttributeLightingFragmentShaderBufferLightUniforms.int)
        encoder.setFragmentTexture(gbufferRenderPass.colorAttachments[0].texture!,
                                   index: kAttributeLightingFragmentShaderTextureAR.int)
        encoder.setFragmentTexture(gbufferRenderPass.colorAttachments[1].texture!,
                                   index: kAttributeLightingFragmentShaderTextureNM.int)
        encoder.setFragmentTexture(gbufferRenderPass.colorAttachments[2].texture!,
                                   index: kAttributeLightingFragmentShaderTexturePR.int)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset,
                                      instanceCount: lightsCount)
    }
}

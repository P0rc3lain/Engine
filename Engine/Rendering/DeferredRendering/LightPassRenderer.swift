//
//  LightPassRenderer.swift
//  Engine
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import simd
import MetalKit
import MetalBinding

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
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(drawableSize.width), height: Double(drawableSize.height),
                                    znear: 0, zfar: 1)
    }
    // MARK: - Internal
    func draw(encoder: inout MTLRenderCommandEncoder, bufferStore: inout BufferStore, lightsCount: Int) {
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer, offset: 0, index: 0)
        
        encoder.setFragmentBuffer(bufferStore.omniLights.buffer, offset: 0, index: 3)
        encoder.setFragmentBuffer(bufferStore.cameras.buffer, offset: 0, index: 1)
        
        encoder.setFragmentTexture(gbufferRenderPass.colorAttachments[0].texture!, index: 0)
        encoder.setFragmentTexture(gbufferRenderPass.colorAttachments[1].texture!, index: 1)
        encoder.setFragmentTexture(gbufferRenderPass.colorAttachments[2].texture!, index: 2)
        encoder.setFragmentBuffer(bufferStore.modelCoordinateSystems.buffer, offset: 0, index: 4)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset,
                                      instanceCount: lightsCount)
    }
}

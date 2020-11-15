//
//  GBufferRenderer.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import simd
import MetalKit
import ShaderTypes

struct GBufferRenderer {
    // MARK: - Properties
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    // MARK: - Initialization
    init(pipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState,
         drawableSize: CGSize,
         renderPassRescriptor: MTLRenderPassDescriptor) {
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(drawableSize.width), height: Double(drawableSize.height),
                                    znear: 0, zfar: 1)
    }
    // MARK: - Internal
    func draw(encoder: inout MTLRenderCommandEncoder, scene: inout Scene, dataStore: inout BufferStore) {
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setCullMode(.back)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setVertexBuffer(dataStore.cameras.buffer, offset: 0, index: 1)
        encoder.setStencilReferenceValue(1)
        for i in 0..<scene.models.count {
            let offset = i * MemoryLayout<ModelUniforms>.stride
            encoder.setVertexBuffer(scene.models[i].modelPiece.geometry.vertexBuffer.buffer, offset: 0, index: 0)
            encoder.setVertexBuffer(dataStore.modelCoordinateSystems.buffer, offset: offset, index: 2)
            encoder.setFragmentBuffer(dataStore.modelCoordinateSystems.buffer, offset: offset, index: 2)
            encoder.setFragmentTexture(scene.models[i].modelPiece.material.albedo, index: 0)
            encoder.setFragmentTexture(scene.models[i].modelPiece.material.roughness, index: 1)
            encoder.setFragmentTexture(scene.models[i].modelPiece.material.normals, index: 2)
            encoder.setFragmentTexture(scene.models[i].modelPiece.material.metallic, index: 3)
            for description in scene.models[i].modelPiece.geometry.drawDescription {
                encoder.drawIndexedPrimitives(type: description.primitiveType,
                                              indexCount: description.indexCount,
                                              indexType: description.indexType,
                                              indexBuffer: description.indexBuffer.buffer,
                                              indexBufferOffset: description.indexBuffer.offset)
            }
        }
    }
}

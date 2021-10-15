//
//  GBufferRenderer.swift
//  Engine
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
                                    width: Double(drawableSize.width),
                                    height: Double(drawableSize.height),
                                    znear: 0, zfar: 1)
    }
    // MARK: - Internal
    func draw(encoder: inout MTLRenderCommandEncoder, scene: inout GPUSceneDescription, dataStore: inout BufferStore) {
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setCullMode(.back)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setVertexBuffer(dataStore.cameras.buffer, offset: 0, index: 1)
        encoder.setStencilReferenceValue(1)
        for i in 0 ..< scene.objects.count {
            let object = scene.objects[i].data
            if object.type == .mesh {
                let mesh = scene.meshes[object.referenceIdx]
                encoder.setVertexBuffer(mesh.vertexBuffer.buffer, offset: mesh.vertexBuffer.offset, index: 0)
                for description in mesh.pieceDescriptions {
                    let material = scene.materials[description.materialIdx]
                    encoder.setFragmentTexture(material.albedo, index: 0)
                    encoder.setFragmentTexture(material.roughness, index: 1)
                    encoder.setFragmentTexture(material.normals, index: 2)
                    encoder.setFragmentTexture(material.metallic, index: 3)
                    encoder.drawIndexedPrimitives(type: description.drawDescription.primitiveType,
                                                  indexCount: description.drawDescription.indexCount,
                                                  indexType: description.drawDescription.indexType,
                                                  indexBuffer: description.drawDescription.indexBuffer.buffer,
                                                  indexBufferOffset: description.drawDescription.indexBuffer.offset)
                }
            }
//            let offset = i * MemoryLayout<ModelUniforms>.stride
//            encoder.setVertexBuffer(dataStore.modelCoordinateSystems.buffer, offset: offset, index: 2)
//            encoder.setFragmentBuffer(dataStore.modelCoordinateSystems.buffer, offset: offset, index: 2)
        }
    }
}

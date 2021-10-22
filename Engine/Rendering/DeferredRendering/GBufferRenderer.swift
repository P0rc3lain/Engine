//
//  GBufferRenderer.swift
//  Engine
//
//  Created by Mateusz Stompór on 14/11/2020.
//

import simd
import MetalKit
import MetalBinding

struct GBufferRenderer {
    // MARK: - Properties
    private let pipelineState: MTLRenderPipelineState
    private let animatedPipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    // MARK: - Initialization
    init(pipelineState: MTLRenderPipelineState,
         animatedPipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState,
         drawableSize: CGSize,
         renderPassRescriptor: MTLRenderPassDescriptor) {
        self.pipelineState = pipelineState
        self.animatedPipelineState = animatedPipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(drawableSize.width),
                                    height: Double(drawableSize.height),
                                    znear: 0, zfar: 1)
    }
    // MARK: - Internal
    func draw(encoder: inout MTLRenderCommandEncoder, scene: inout GPUSceneDescription, dataStore: inout BufferStore) {
        encoder.setViewport(viewPort)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setCullMode(.back)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setVertexBuffer(dataStore.cameras.buffer, offset: 0, index: 1)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(animatedPipelineState)
        for i in 0 ..< scene.objects.count {
            let object = scene.objects[i].data
            if object.type == .mesh && scene.skeletonReferences[i] != .nil {
                let mesh = scene.meshes[object.referenceIdx]
                encoder.setVertexBuffer(mesh.vertexBuffer.buffer, offset: mesh.vertexBuffer.offset, index: 0)
                for description in mesh.pieceDescriptions {
                    let offset = i * MemoryLayout<ModelUniforms>.stride
                    encoder.setVertexBuffer(dataStore.modelCoordinateSystems.buffer, offset: offset, index: 2)
                    encoder.setVertexBuffer(dataStore.matrixPalettes.buffer, offset: scene.paletteReferences[i].idx, index: 3)
                    let material = scene.materials[description.materialIdx]
                    encoder.setFragmentTextures([material.albedo, material.roughness, material.normals, material.metallic], range: 0 ..< 4)
                    encoder.drawIndexedPrimitives(type: description.drawDescription.primitiveType,
                                                  indexCount: description.drawDescription.indexCount,
                                                  indexType: description.drawDescription.indexType,
                                                  indexBuffer: description.drawDescription.indexBuffer.buffer,
                                                  indexBufferOffset: description.drawDescription.indexBuffer.offset)
                }
            }
        }
        encoder.setRenderPipelineState(pipelineState)
        for i in 0 ..< scene.objects.count {
            let object = scene.objects[i].data
            if object.type == .mesh && scene.skeletonReferences[i] == .nil {
                let mesh = scene.meshes[object.referenceIdx]
                encoder.setVertexBuffer(mesh.vertexBuffer.buffer, offset: mesh.vertexBuffer.offset, index: 0)
                for description in mesh.pieceDescriptions {
                    let offset = i * MemoryLayout<ModelUniforms>.stride
                    encoder.setVertexBuffer(dataStore.modelCoordinateSystems.buffer, offset: offset, index: 2)
                    let material = scene.materials[description.materialIdx]
                    encoder.setFragmentTextures([material.albedo, material.roughness, material.normals, material.metallic], range: 0 ..< 4)
                    encoder.drawIndexedPrimitives(type: description.drawDescription.primitiveType,
                                                  indexCount: description.drawDescription.indexCount,
                                                  indexType: description.drawDescription.indexType,
                                                  indexBuffer: description.drawDescription.indexBuffer.buffer,
                                                  indexBufferOffset: description.drawDescription.indexBuffer.offset)
                }
            }
        }
    }
}

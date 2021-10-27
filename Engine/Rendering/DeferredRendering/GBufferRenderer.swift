//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import MetalKit
import simd

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
        self.viewPort = .porcelain(size: drawableSize)
    }
    // MARK: - Internal
    func draw(encoder: inout MTLRenderCommandEncoder, scene: inout GPUSceneDescription, dataStore: inout BufferStore) {
        encoder.setViewport(viewPort)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setCullMode(.back)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setVertexBuffer(dataStore.cameras.buffer,
                                index: kAttributeGBufferVertexShaderBufferCameraUniforms.int)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(animatedPipelineState)
        let texturesRange = Range(kAttributeGBufferFragmentShaderTextureAlbedo.int ... kAttributeGBufferFragmentShaderTextureMetallic.int)
        for index in scene.objects.indices {
            let object = scene.objects[index].data
            if object.type == .mesh && scene.skeletonReferences[index] != .nil {
                let mesh = scene.meshes[object.referenceIdx]
                encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                        offset: mesh.vertexBuffer.offset,
                                        index: kAttributeGBufferVertexShaderBufferStageIn.int)
                for description in mesh.pieceDescriptions {
                    let offset = index * MemoryLayout<ModelUniforms>.stride
                    encoder.setVertexBuffer(dataStore.modelCoordinateSystems.buffer,
                                            offset: offset,
                                            index: kAttributeGBufferVertexShaderBufferModelUniforms.int)
                    encoder.setVertexBuffer(dataStore.matrixPalettes.buffer,
                                            offset: scene.paletteReferences[index].lowerBound,
                                            index: kAttributeGBufferVertexShaderBufferMatrixPalettes.int)
                    let material = scene.materials[description.materialIdx]
                    encoder.setFragmentTextures([material.albedo, material.roughness, material.normals, material.metallic],
                                                range: texturesRange)
                    encoder.drawIndexedPrimitives(type: description.drawDescription.primitiveType,
                                                  indexCount: description.drawDescription.indexCount,
                                                  indexType: description.drawDescription.indexType,
                                                  indexBuffer: description.drawDescription.indexBuffer.buffer,
                                                  indexBufferOffset: description.drawDescription.indexBuffer.offset)
                }
            }
        }
        encoder.setRenderPipelineState(pipelineState)
        for index in scene.objects.indices {
            let object = scene.objects[index].data
            if object.type == .mesh && scene.skeletonReferences[index] == .nil {
                let mesh = scene.meshes[object.referenceIdx]
                encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                        offset: mesh.vertexBuffer.offset,
                                        index: kAttributeGBufferVertexShaderBufferStageIn.int)
                for description in mesh.pieceDescriptions {
                    let offset = index * MemoryLayout<ModelUniforms>.stride
                    encoder.setVertexBuffer(dataStore.modelCoordinateSystems.buffer,
                                            offset: offset,
                                            index: kAttributeGBufferVertexShaderBufferModelUniforms.int)
                    let material = scene.materials[description.materialIdx]
                    encoder.setFragmentTextures([material.albedo, material.roughness, material.normals, material.metallic],
                                                range: texturesRange)
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

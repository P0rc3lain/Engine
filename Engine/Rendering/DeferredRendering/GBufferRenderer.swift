//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import MetalKit
import simd

struct GBufferRenderer {
    private let pipelineState: MTLRenderPipelineState
    private let animatedPipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
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
    func draw(encoder: inout MTLRenderCommandEncoder, scene: inout GPUSceneDescription, dataStore: inout BufferStore) {
        encoder.setViewport(viewPort)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setCullMode(.back)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setVertexBuffer(dataStore.cameras.buffer,
                                index: kAttributeGBufferVertexShaderBufferCameraUniforms)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(animatedPipelineState)
        let texturesRange = kAttributeGBufferFragmentShaderTextureAlbedo.int ... kAttributeGBufferFragmentShaderTextureMetallic.int
        for index in scene.entities.indices {
            let object = scene.entities[index].data
            if object.type == .mesh && scene.skeletonReferences[index] != .nil {
                let mesh = scene.meshBuffers[object.referenceIdx]
                encoder.setVertexBuffer(mesh.buffer,
                                        offset: mesh.offset,
                                        index: kAttributeGBufferVertexShaderBufferStageIn)
                var mutableIndex = Int32(index)
                encoder.setVertexBytes(&mutableIndex,
                                       length: MemoryLayout<Int32>.size,
                                       index: kAttributeGBufferVertexShaderBufferObjectIndex)
                for pieceIndex in scene.indexDrawReferences[object.referenceIdx].indices {
                    encoder.setVertexBuffer(dataStore.modelCoordinateSystems.buffer,
                                            index: kAttributeGBufferVertexShaderBufferModelUniforms)
                    encoder.setVertexBuffer(dataStore.matrixPalettes.buffer,
                                            offset: scene.paletteReferences[index].lowerBound,
                                            index: kAttributeGBufferVertexShaderBufferMatrixPalettes)
                    let material = scene.materials[scene.indexDrawsMaterials[pieceIndex]]
                    encoder.setFragmentTextures([material.albedo, material.roughness, material.normals, material.metallic],
                                                range: texturesRange)
                    let indexDraw = scene.indexDraws[pieceIndex]
                    encoder.drawIndexedPrimitives(type: indexDraw.primitiveType,
                                                  indexCount: indexDraw.indexCount,
                                                  indexType: indexDraw.indexType,
                                                  indexBuffer: indexDraw.indexBuffer.buffer,
                                                  indexBufferOffset: indexDraw.indexBuffer.offset)
                }
            }
        }
        encoder.setRenderPipelineState(pipelineState)
        for index in scene.entities.indices {
            let object = scene.entities[index].data
            if object.type == .mesh && scene.skeletonReferences[index] == .nil {
                let mesh = scene.meshBuffers[object.referenceIdx]
                encoder.setVertexBuffer(mesh.buffer,
                                        offset: mesh.offset,
                                        index: kAttributeGBufferVertexShaderBufferStageIn)
                var mutableIndex = Int32(index)
                encoder.setVertexBytes(&mutableIndex,
                                       length: MemoryLayout<Int32>.size,
                                       index: kAttributeGBufferVertexShaderBufferObjectIndex)
                for pieceIndex in scene.indexDrawReferences[object.referenceIdx].indices {
                    encoder.setVertexBuffer(dataStore.modelCoordinateSystems.buffer,
                                            index: kAttributeGBufferVertexShaderBufferModelUniforms)
                    let material = scene.materials[scene.indexDrawsMaterials[pieceIndex]]
                    encoder.setFragmentTextures([material.albedo, material.roughness, material.normals, material.metallic],
                                                range: texturesRange)
                        let indexDraw = scene.indexDraws[pieceIndex]
                    encoder.drawIndexedPrimitives(type: indexDraw.primitiveType,
                                                  indexCount: indexDraw.indexCount,
                                                  indexType: indexDraw.indexType,
                                                  indexBuffer: indexDraw.indexBuffer.buffer,
                                                  indexBufferOffset: indexDraw.indexBuffer.offset)
                }
            }
        }
    }
}

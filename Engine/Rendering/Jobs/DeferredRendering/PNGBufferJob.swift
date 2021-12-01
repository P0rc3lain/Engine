//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import MetalKit
import simd

struct PNGBufferJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let animatedPipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    init(pipelineState: MTLRenderPipelineState,
         animatedPipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState,
         drawableSize: CGSize) {
        self.pipelineState = pipelineState
        self.animatedPipelineState = animatedPipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = .porcelain(size: drawableSize)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let scene = supply.scene
        let dataStore = supply.bufferStore
        let mask = supply.mask.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx]
        encoder.setViewport(viewPort)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setCullMode(.back)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setVertexBuffer(dataStore.cameras.buffer,
                                index: kAttributeGBufferVertexShaderBufferCameraUniforms)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(animatedPipelineState)
        let texturesRange = kAttributeGBufferFragmentShaderTextureAlbedo ... kAttributeGBufferFragmentShaderTextureMetallic
        for animatedModel in scene.animatedModels {
            if !mask[animatedModel.idx] {
                continue
            }
            let mesh = scene.meshes[animatedModel.mesh]
            encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                    offset: mesh.vertexBuffer.offset,
                                    index: kAttributeGBufferVertexShaderBufferStageIn)
            var mutableIndex = Int32(animatedModel.idx)
            encoder.setVertexBytes(&mutableIndex,
                                   length: MemoryLayout<Int32>.size,
                                   index: kAttributeGBufferVertexShaderBufferObjectIndex)
            encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                    index: kAttributeGBufferVertexShaderBufferModelUniforms)
            for pieceIndex in mesh.pieceDescriptions {
                encoder.setVertexBuffer(dataStore.matrixPalettes,
                                        offset: scene.paletteOffset[animatedModel.skeleton],
                                        index: kAttributeGBufferVertexShaderBufferMatrixPalettes)
                if let material = pieceIndex.material {
                    encoder.setFragmentTextures([material.albedo,
                                                 material.roughness,
                                                 material.normals,
                                                 material.metallic],
                                                range: texturesRange)
                }
                let indexDraw = pieceIndex.drawDescription
                encoder.drawIndexedPrimitives(type: indexDraw.primitiveType,
                                              indexCount: indexDraw.indexCount,
                                              indexType: indexDraw.indexType,
                                              indexBuffer: indexDraw.indexBuffer.buffer,
                                              indexBufferOffset: indexDraw.indexBuffer.offset)
            }
        }
        encoder.setRenderPipelineState(pipelineState)
        for model in scene.models {
            if !mask[model.idx] {
                continue
            }
            let mesh = scene.meshes[model.mesh]
            encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                    offset: mesh.vertexBuffer.offset,
                                    index: kAttributeGBufferVertexShaderBufferStageIn)
            var mutableIndex = Int32(model.idx)
            encoder.setVertexBytes(&mutableIndex,
                                   length: MemoryLayout<Int32>.size,
                                   index: kAttributeGBufferVertexShaderBufferObjectIndex)
            encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                    index: kAttributeGBufferVertexShaderBufferModelUniforms)
            for pieceIndex in mesh.pieceDescriptions {
                if let material = pieceIndex.material {
                    encoder.setFragmentTextures([material.albedo,
                                                 material.roughness,
                                                 material.normals,
                                                 material.metallic],
                                                range: texturesRange)
                }
                let indexDraw = pieceIndex.drawDescription
                encoder.drawIndexedPrimitives(type: indexDraw.primitiveType,
                                              indexCount: indexDraw.indexCount,
                                              indexType: indexDraw.indexType,
                                              indexBuffer: indexDraw.indexBuffer.buffer,
                                              indexBufferOffset: indexDraw.indexBuffer.offset)
            }
        }
    }
}

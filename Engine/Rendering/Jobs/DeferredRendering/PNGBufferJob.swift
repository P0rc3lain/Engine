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
        encoder.setVertexBuffer(dataStore.cameras.buffer,
                                index: kAttributeGBufferVertexShaderBufferCameraUniforms)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                index: kAttributeGBufferVertexShaderBufferModelUniforms)
        let texturesRange = kAttributeGBufferFragmentShaderTextureAlbedo ... kAttributeGBufferFragmentShaderTextureMetallic
        for animatedModel in scene.animatedModels {
            if !mask[animatedModel.idx] {
                continue
            }
            let mesh = scene.meshes[animatedModel.mesh]
            encoder.setBackCulling(mesh.culling)
            encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                    offset: mesh.vertexBuffer.offset,
                                    index: kAttributeGBufferVertexShaderBufferStageIn)
            encoder.setVertexBytes(value: Int32(animatedModel.idx),
                                   index: kAttributeGBufferVertexShaderBufferObjectIndex)
            encoder.setVertexBuffer(dataStore.matrixPalettes,
                                    offset: scene.paletteOffset[animatedModel.skeleton],
                                    index: kAttributeGBufferVertexShaderBufferMatrixPalettes)
            for pieceDescription in mesh.pieceDescriptions {
                if let material = pieceDescription.material {
                    encoder.setFragmentTextures([material.albedo,
                                                 material.roughness,
                                                 material.normals,
                                                 material.metallic],
                                                range: texturesRange)
                }
                encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
            }
        }
        encoder.setRenderPipelineState(pipelineState)
        for model in scene.models {
            if !mask[model.idx] {
                continue
            }
            let mesh = scene.meshes[model.mesh]
            encoder.setBackCulling(mesh.culling)
            encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                    offset: mesh.vertexBuffer.offset,
                                    index: kAttributeGBufferVertexShaderBufferStageIn)
            encoder.setVertexBytes(value: Int32(model.idx),
                                   index: kAttributeGBufferVertexShaderBufferObjectIndex)
            for pieceDescription in mesh.pieceDescriptions {
                if let material = pieceDescription.material {
                    encoder.setFragmentTextures([material.albedo,
                                                 material.roughness,
                                                 material.normals,
                                                 material.metallic],
                                                range: texturesRange)
                }
                encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
            }
        }
    }
}

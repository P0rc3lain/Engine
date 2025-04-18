//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import simd

struct PNTranslucentJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let animatedPipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    init(pipelineState: MTLRenderPipelineState,
         animatedPipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState) {
        self.pipelineState = pipelineState
        self.animatedPipelineState = animatedPipelineState
        self.depthStencilState = depthStencilState
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let scene = supply.scene
        let dataStore = supply.bufferStore
        let mask = supply.mask.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx]
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(dataStore.cameras.buffer,
                                index: kAttributeTranslucentVertexShaderBufferCameraUniforms)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                index: kAttributeTranslucentVertexShaderBufferModelUniforms)
        for animatedModel in scene.animatedModels {
            if !mask[animatedModel.idx] {
                continue
            }
            encoder.setVertexBuffer(dataStore.matrixPalettes,
                                    offset: scene.paletteOffset[animatedModel.skeleton],
                                    index: kAttributeTranslucentVertexShaderBufferMatrixPalettes)
            draw(encoder: encoder,
                 mesh: scene.meshes[animatedModel.mesh],
                 uniformReference: animatedModel.idx)
        }
        encoder.setRenderPipelineState(pipelineState)
        for model in scene.models {
            if !mask[model.idx] {
                continue
            }
            draw(encoder: encoder,
                 mesh: scene.meshes[model.mesh],
                 uniformReference: model.idx)
        }
    }
    private func draw(encoder: MTLRenderCommandEncoder, mesh: PNMesh, uniformReference: PNIndex) {
        encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                offset: mesh.vertexBuffer.offset,
                                index: kAttributeTranslucentVertexShaderBufferStageIn)
        encoder.setVertexBytes(value: uniformReference,
                               index: kAttributeTranslucentVertexShaderBufferObjectIndex)
        for pieceDescription in mesh.pieceDescriptions {
            guard let material = pieceDescription.material,
                  material.isTranslucent else {
                continue
            }
            encoder.setFragmentTexture(material.albedo,
                                       index: kAttributeTranslucentFragmentShaderTextureAlbedo)
            encoder.setFrontCulling(mesh.culling)
            encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
            encoder.setBackCulling(mesh.culling)
            encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
        }
    }
    static func make(device: MTLDevice) -> PNTranslucentJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRPSTranslucent(library: library)
        let animatedPipelineState = device.makeRPSTranslucentAnimated(library: library)
        let depthStencilState = device.makeDSSTranslucent()
        return PNTranslucentJob(pipelineState: pipelineState,
                                animatedPipelineState: animatedPipelineState,
                                depthStencilState: depthStencilState)
    }
}

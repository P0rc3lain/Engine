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
        let mask = supply.mask.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx]
        
        let animatedModels = scene.animatedModels.filter { animatedModel in
            if !mask[animatedModel.idx] {
                return false
            }
            return scene.meshes[animatedModel.mesh].hasTranslucentSubmesh()
        }
        
        let models = scene.models.filter { model in
            if !mask[model.idx] {
                return false
            }
            return scene.meshes[model.mesh].hasTranslucentSubmesh()
        }
        
        guard models.count > 0 || animatedModels.count > 0 else {
            return
        }
        
        let dataStore = supply.bufferStore
        encoder.setCullMode(.none)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(dataStore.cameras.buffer,
                                index: kAttributeTranslucentVertexShaderBufferCameraUniforms)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                index: kAttributeTranslucentVertexShaderBufferModelUniforms)
        for animatedModel in animatedModels {
            encoder.setVertexBuffer(dataStore.matrixPalettes,
                                    offset: scene.paletteOffset[animatedModel.skeleton],
                                    index: kAttributeTranslucentVertexShaderBufferMatrixPalettes)
            draw(encoder: encoder,
                 mesh: scene.meshes[animatedModel.mesh],
                 uniformReference: animatedModel.idx)
        }
        encoder.setRenderPipelineState(pipelineState)
        for model in models {
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

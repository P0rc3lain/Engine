//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import PNShared
import Metal
import simd

struct PNGBufferJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let animatedPipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let textureRange = kAttributeGBufferFragmentShaderTextureAlbedo ...
                               kAttributeGBufferFragmentShaderTextureMetallic
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
                                index: kAttributeGBufferVertexShaderBufferCameraUniforms)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                index: kAttributeGBufferVertexShaderBufferModelUniforms)
        for animatedModel in scene.animatedModels {
            if !mask[animatedModel.idx] {
                continue
            }
            encoder.setVertexBuffer(dataStore.matrixPalettes,
                                    offset: scene.paletteOffset[animatedModel.skeleton],
                                    index: kAttributeGBufferVertexShaderBufferMatrixPalettes)
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
        encoder.setBackCulling(mesh.culling)
        encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                offset: mesh.vertexBuffer.offset,
                                index: kAttributeGBufferVertexShaderBufferStageIn)
        encoder.setVertexBytes(value: uniformReference,
                               index: kAttributeGBufferVertexShaderBufferObjectIndex)
        for pieceDescription in mesh.pieceDescriptions {
            guard let material = pieceDescription.material,
                  !material.isTranslucent else {
                continue
            }
            encoder.setFragmentTextures([material.albedo,
                                         material.roughness,
                                         material.normals,
                                         material.metallic],
                                        range: textureRange)
            encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
        }
    }
    static func make(device: MTLDevice) -> PNGBufferJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSGBuffer(library: library),
              let animatedPipelineState = device.makeRPSGBufferAnimated(library: library),
              let depthStencilState = device.makeDSSGBuffer() else {
            return nil
        }
        return PNGBufferJob(pipelineState: pipelineState,
                            animatedPipelineState: animatedPipelineState,
                            depthStencilState: depthStencilState)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import simd

struct PNGBufferJob: PNRenderJob {
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
                                index: kAttributeGBufferVertexShaderBufferCameraUniforms)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                index: kAttributeGBufferVertexShaderBufferModelUniforms)
        encoder.setVertexBuffer(dataStore.previousModelCoordinateSystems,
                                index: kAttributeGBufferVertexShaderBufferModelUniformsPreviousFrame)
        for animatedModel in scene.animatedModels {
            if !mask[animatedModel.idx] {
                continue
            }
            encoder.setVertexBuffer(dataStore.matrixPalettes,
                                    offset: scene.paletteOffset[animatedModel.skeleton],
                                    index: kAttributeGBufferVertexShaderBufferMatrixPalettes)
            encoder.setVertexBuffer(dataStore.previousMatrixPalettes,
                                    offset: scene.paletteOffset[animatedModel.skeleton],
                                    index: kAttributeGBufferVertexShaderBufferMatrixPalettesPreviousFrame)
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

            encoder.useResource(material.albedo, usage: .read, stages: .fragment)
            encoder.useResource(material.roughness, usage: .read, stages: .fragment)
            encoder.useResource(material.normals, usage: .read, stages: .fragment)
            encoder.useResource(material.metallic, usage: .read, stages: .fragment)
            
            encoder.setFragmentBuffer(material.argumentBuffer,
                                      index: kAttributeGBufferFragmentShaderBufferMaterial)
            encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
        }
    }
    static func make(device: MTLDevice) -> PNGBufferJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRPSGBuffer(library: library)
        let animatedPipelineState = device.makeRPSGBufferAnimated(library: library)
        let depthStencilState = device.makeDSSGBuffer()
        return PNGBufferJob(pipelineState: pipelineState,
                            animatedPipelineState: animatedPipelineState,
                            depthStencilState: depthStencilState)
    }
}

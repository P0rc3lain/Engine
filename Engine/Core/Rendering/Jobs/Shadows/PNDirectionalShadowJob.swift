//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNAttribute

struct PNDirectionalShadowJob: PNRenderJob {
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
        let shadowCasterIndices = supply.scene.directionalLights.indices.filter {
            supply.scene.directionalLights[$0].castsShadows == 1
        }
        guard !shadowCasterIndices.isEmpty else {
            return
        }
        encoder.setCullMode(.front)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(dataStore.directionalLights,
                                index: kAttributeDirectionalShadowVertexShaderBufferDirectionalLights)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                index: kAttributeDirectionalShadowVertexShaderBufferModelUniforms)
        for lightIndex in shadowCasterIndices {
            encoder.setVertexBytes(value: lightIndex,
                                   index: kAttributeDirectionalShadowVertexShaderBufferInstanceId)
            for animatedModel in scene.animatedModels {
                encoder.setVertexBuffer(dataStore.matrixPalettes.buffer,
                                        offset: scene.paletteOffset[animatedModel.skeleton],
                                        index: kAttributeDirectionalShadowVertexShaderBufferMatrixPalettes)
                draw(encoder: encoder,
                     mesh: scene.meshes[animatedModel.mesh],
                     uniformReference: animatedModel.idx)
            }
        }
        encoder.setRenderPipelineState(pipelineState)
        for lightIndex in scene.directionalLights.count.exclusiveON {
            encoder.setVertexBytes(value: lightIndex,
                                   index: kAttributeDirectionalShadowVertexShaderBufferInstanceId)
            for model in scene.models {
                draw(encoder: encoder,
                     mesh: scene.meshes[model.mesh],
                     uniformReference: model.idx)
            }
        }
    }
    private func draw(encoder: MTLRenderCommandEncoder, mesh: PNMesh, uniformReference: PNIndex) {
        encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                offset: mesh.vertexBuffer.offset,
                                index: kAttributeDirectionalShadowVertexShaderBufferStageIn)
        encoder.setVertexBytes(value: uniformReference,
                               index: kAttributeDirectionalShadowVertexShaderBufferObjectIndex)
        for pieceDescription in mesh.pieceDescriptions {
            if let material = pieceDescription.material, material.isTranslucent {
                continue
            }
            encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
        }
    }
    static func make(device: MTLDevice) -> PNDirectionalShadowJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRPSDirectionalShadow(library: library)
        let animatedPipelineState = device.makeRPSDirectionalShadowAnimated(library: library)
        let depthStencilState = device.makeDSSDirectionalLightShadow()
        return PNDirectionalShadowJob(pipelineState: pipelineState,
                                      animatedPipelineState: animatedPipelineState,
                                      depthStencilState: depthStencilState)
    }
}

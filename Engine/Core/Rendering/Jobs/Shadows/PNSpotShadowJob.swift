//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared

struct PNSpotShadowJob: PNRenderJob {
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
        let shadowCasterIndices = supply.scene.spotLights.indices.filter {
            supply.scene.spotLights[$0].castsShadows == 1
        }
        guard !shadowCasterIndices.isEmpty else {
            return
        }
        encoder.setDepthStencilState(depthStencilState)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(dataStore.spotLights,
                                index: kAttributeSpotShadowVertexShaderBufferSpotLights)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                index: kAttributeSpotShadowVertexShaderBufferModelUniforms)
        let masks = supply.mask.spotLights
        for lightIndex in shadowCasterIndices {
            encoder.setVertexBytes(value: lightIndex,
                                   index: kAttributeSpotShadowVertexShaderBufferInstanceId)
            for animatedModel in scene.animatedModels {
                if !masks[lightIndex][animatedModel.idx] {
                    continue
                }
                let mesh = scene.meshes[animatedModel.mesh]
                encoder.setFrontCulling(mesh.culling)
                encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                        offset: mesh.vertexBuffer.offset,
                                        index: kAttributeSpotShadowVertexShaderBufferStageIn)
                encoder.setVertexBytes(value: animatedModel.idx,
                                       index: kAttributeSpotShadowVertexShaderBufferObjectIndex)
                encoder.setVertexBuffer(dataStore.matrixPalettes.buffer,
                                        offset: scene.paletteOffset[animatedModel.skeleton],
                                        index: kAttributeSpotShadowVertexShaderBufferMatrixPalettes)
                for pieceDescription in mesh.pieceDescriptions {
                    encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
                }
            }
            encoder.setRenderPipelineState(pipelineState)
            for model in scene.models {
                if !masks[lightIndex][model.idx] {
                    continue
                }
                let mesh = scene.meshes[model.mesh]
                encoder.setFrontCulling(mesh.culling)
                encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                        offset: mesh.vertexBuffer.offset,
                                        index: kAttributeSpotShadowVertexShaderBufferStageIn)
                encoder.setVertexBytes(value: model.idx,
                                       index: kAttributeSpotShadowVertexShaderBufferObjectIndex)
                for pieceDescription in mesh.pieceDescriptions {
                    if let material = pieceDescription.material, material.isTranslucent {
                        continue
                    }
                    encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
                }
            }
        }
    }
    static func make(device: MTLDevice) -> PNSpotShadowJob? {
        let library = device.makePorcelainLibrary()
        let animatedPipelineState = device.makeRPSSpotShadowAnimated(library: library)
        let depthStencilState = device.makeDSSSpotShadow()
        let pipelineState = device.makeRPSSpotShadow(library: library)
        return PNSpotShadowJob(pipelineState: pipelineState,
                               animatedPipelineState: animatedPipelineState,
                               depthStencilState: depthStencilState)
    }
}

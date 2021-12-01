//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

struct PNSpotShadowJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let animatedPipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    init(pipelineState: MTLRenderPipelineState,
         animatedPipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState,
         viewPort: MTLViewport) {
        self.pipelineState = pipelineState
        self.animatedPipelineState = animatedPipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = viewPort
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let scene = supply.scene
        let dataStore = supply.bufferStore
        guard !scene.spotLights.isEmpty else {
            return
        }
        encoder.setViewport(viewPort)
        encoder.setCullMode(.front)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(dataStore.spotLights,
                                index: kAttributeSpotShadowVertexShaderBufferSpotLights)
        let masks = supply.mask.spotLights
        for lightIndex in scene.spotLights.count.naturalExclusive {
            var lIndex = lightIndex
            encoder.setVertexBytes(&lIndex,
                                   length: MemoryLayout<Int>.size,
                                   index: kAttributeSpotShadowVertexShaderBufferInstanceId)
            for animatedModel in scene.animatedModels {
                if !masks[lightIndex][animatedModel.idx] {
                    continue
                }
                let mesh = scene.meshes[animatedModel.mesh]
                encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                        offset: mesh.vertexBuffer.offset,
                                        index: kAttributeSpotShadowVertexShaderBufferStageIn)
                var mutableIndex = Int32(animatedModel.idx)
                encoder.setVertexBytes(&mutableIndex,
                                       length: MemoryLayout<Int32>.size,
                                       index: kAttributeSpotShadowVertexShaderBufferObjectIndex)
                encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                        index: kAttributeSpotShadowVertexShaderBufferModelUniforms)
                for pieceIndex in mesh.pieceDescriptions {
                    encoder.setVertexBuffer(dataStore.matrixPalettes.buffer,
                                            offset: scene.paletteOffset[animatedModel.skeleton],
                                            index: kAttributeSpotShadowVertexShaderBufferMatrixPalettes)
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
                if !masks[lightIndex][model.idx] {
                    continue
                }
                let mesh = scene.meshes[model.mesh]
                encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                        offset: mesh.vertexBuffer.buffer.offset,
                                        index: kAttributeSpotShadowVertexShaderBufferStageIn)
                var mutableIndex = Int32(model.idx)
                encoder.setVertexBytes(&mutableIndex,
                                       length: MemoryLayout<Int32>.size,
                                       index: kAttributeSpotShadowVertexShaderBufferObjectIndex)
                encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                        index: kAttributeSpotShadowVertexShaderBufferModelUniforms)
                for pieceIndex in mesh.pieceDescriptions {
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
}

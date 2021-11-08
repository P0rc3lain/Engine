//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

struct SpotShadowRenderer {
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
    func draw(encoder: inout MTLRenderCommandEncoder,
              scene: inout GPUSceneDescription,
              dataStore: inout BufferStore) {
        guard !scene.spotLights.isEmpty else {
            return
        }
        encoder.setViewport(viewPort)
        encoder.setCullMode(.front)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setRenderPipelineState(animatedPipelineState)
        for index in scene.entities.indices {
            let object = scene.entities[index].data
            if object.type == .mesh && scene.skeletonReferences[index] != .nil {
                let mesh = scene.meshBuffers[object.referenceIdx]
                encoder.setVertexBuffer(mesh.buffer,
                                        offset: mesh.offset,
                                        index: kAttributeSpotShadowVertexShaderBufferStageIn)
                var mutableIndex = Int32(index)
                encoder.setVertexBytes(&mutableIndex,
                                       length: MemoryLayout<Int32>.size,
                                       index: kAttributeSpotShadowVertexShaderBufferObjectIndex)
                encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                        index: kAttributeSpotShadowVertexShaderBufferModelUniforms)
                encoder.setVertexBuffer(dataStore.spotLights,
                                        index: kAttributeSpotShadowVertexShaderBufferSpotLights)
                for pieceIndex in scene.indexDrawReferences[object.referenceIdx].indices {
                    encoder.setVertexBuffer(dataStore.matrixPalettes.buffer,
                                            offset: scene.paletteReferences[index].lowerBound,
                                            index: kAttributeSpotShadowVertexShaderBufferMatrixPalettes)
                    let indexDraw = scene.indexDraws[pieceIndex]
                    encoder.drawIndexedPrimitives(type: indexDraw.primitiveType,
                                                  indexCount: indexDraw.indexCount,
                                                  indexType: indexDraw.indexType,
                                                  indexBuffer: indexDraw.indexBuffer.buffer,
                                                  indexBufferOffset: indexDraw.indexBuffer.offset,
                                                  instanceCount: scene.spotLights.count)
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
                                        index: kAttributeSpotShadowVertexShaderBufferStageIn)
                var mutableIndex = Int32(index)
                encoder.setVertexBytes(&mutableIndex,
                                       length: MemoryLayout<Int32>.size,
                                       index: kAttributeSpotShadowVertexShaderBufferObjectIndex)
                encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                        index: kAttributeSpotShadowVertexShaderBufferModelUniforms)
                encoder.setVertexBuffer(dataStore.spotLights,
                                        index: kAttributeSpotShadowVertexShaderBufferSpotLights)
                for pieceIndex in scene.indexDrawReferences[object.referenceIdx].indices {
                    let indexDraw = scene.indexDraws[pieceIndex]
                    encoder.drawIndexedPrimitives(type: indexDraw.primitiveType,
                                                  indexCount: indexDraw.indexCount,
                                                  indexType: indexDraw.indexType,
                                                  indexBuffer: indexDraw.indexBuffer.buffer,
                                                  indexBufferOffset: indexDraw.indexBuffer.offset,
                                                  instanceCount: scene.spotLights.count)
                }
            }
        }
    }
}

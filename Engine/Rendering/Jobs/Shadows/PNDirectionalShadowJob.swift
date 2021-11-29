//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

struct PNDirectionalShadowJob: PNRenderJob {
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
        guard !scene.directionalLights.isEmpty else {
            return
        }
        encoder.setViewport(viewPort)
        encoder.setCullMode(.front)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(dataStore.directionalLights,
                                index: kAttributeDirectionalShadowVertexShaderBufferDirectionalLights)
        for lightIndex in scene.directionalLights.count.naturalExclusive {
            var lIndex = lightIndex
            encoder.setVertexBytes(&lIndex,
                                   length: MemoryLayout<Int>.size,
                                   index: kAttributeDirectionalShadowVertexShaderBufferInstanceId)
            for index in scene.entities.indices {
                let object = scene.entities[index].data
                if object.type == .mesh && scene.skeletonReferences[index] != .nil {
                    let mesh = scene.meshes[object.referenceIdx]
                    encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                            offset: mesh.vertexBuffer.offset,
                                            index: kAttributeDirectionalShadowVertexShaderBufferStageIn)
                    var mutableIndex = Int32(index)
                    encoder.setVertexBytes(&mutableIndex,
                                           length: MemoryLayout<Int32>.size,
                                           index: kAttributeDirectionalShadowVertexShaderBufferObjectIndex)
                    encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                            index: kAttributeDirectionalShadowVertexShaderBufferModelUniforms)
                    for pieceIndex in mesh.pieceDescriptions {
                        encoder.setVertexBuffer(dataStore.matrixPalettes.buffer,
                                                offset: scene.paletteOffset[index],
                                                index: kAttributeDirectionalShadowVertexShaderBufferMatrixPalettes)
                        let indexDraw = pieceIndex.drawDescription
                        encoder.drawIndexedPrimitives(type: indexDraw.primitiveType,
                                                      indexCount: indexDraw.indexCount,
                                                      indexType: indexDraw.indexType,
                                                      indexBuffer: indexDraw.indexBuffer.buffer,
                                                      indexBufferOffset: indexDraw.indexBuffer.offset)
                    }
                }
            }
            encoder.setRenderPipelineState(pipelineState)
            for index in scene.entities.indices {
                let object = scene.entities[index].data
                if object.type == .mesh && scene.skeletonReferences[index] == .nil {
                    let mesh = scene.meshes[object.referenceIdx]
                    encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                            offset: mesh.vertexBuffer.buffer.offset,
                                            index: kAttributeDirectionalShadowVertexShaderBufferStageIn)
                    var mutableIndex = Int32(index)
                    encoder.setVertexBytes(&mutableIndex,
                                           length: MemoryLayout<Int32>.size,
                                           index: kAttributeDirectionalShadowVertexShaderBufferObjectIndex)
                    encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                            index: kAttributeDirectionalShadowVertexShaderBufferModelUniforms)
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
}

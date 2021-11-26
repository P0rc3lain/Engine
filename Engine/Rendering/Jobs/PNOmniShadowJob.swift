//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNOmniShadowJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let animatedPipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private var rotationsBuffer: PNAnyStaticBuffer<simd_float4x4>
    private let viewPort: MTLViewport
    init(pipelineState: MTLRenderPipelineState,
         animatedPipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState,
         rotationsBuffer: PNAnyStaticBuffer<simd_float4x4>,
         viewPort: MTLViewport) {
        self.pipelineState = pipelineState
        self.animatedPipelineState = animatedPipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = viewPort
        self.rotationsBuffer = rotationsBuffer
        var rotations = PNOmniShadowJob.rotationMatrices
        self.rotationsBuffer.upload(data: &rotations)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let scene = supply.scene
        let dataStore = supply.bufferStore
        guard !scene.omniLights.isEmpty else {
            return
        }
        let masks = supply.mask.omniLights
        encoder.setViewport(viewPort)
        encoder.setCullMode(.front)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(rotationsBuffer,
                                index: kAttributeOmniShadowVertexShaderBufferRotations)
        encoder.setVertexBuffer(dataStore.omniLights,
                                index: kAttributeOmniShadowVertexShaderBufferOmniLights)
        for lightIndex in scene.omniLights.count.naturalExclusive {
            for faceIndex in 6.naturalExclusive {
                var lIndex = lightIndex + faceIndex
                encoder.setVertexBytes(&lIndex,
                                       length: MemoryLayout<Int>.size,
                                       index: kAttributeOmniShadowVertexShaderBufferInstanceId)
                for index in scene.entities.indices {
                    if !masks[lightIndex][faceIndex][index] {
                        continue
                    }
                    let object = scene.entities[index].data
                    if object.type == .mesh && scene.skeletonReferences[index] != .nil {
                        let mesh = scene.meshes[object.referenceIdx]
                        encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                                offset: mesh.vertexBuffer.offset,
                                                index: kAttributeOmniShadowVertexShaderBufferStageIn)
                        var mutableIndex = Int32(index)
                        encoder.setVertexBytes(&mutableIndex,
                                               length: MemoryLayout<Int32>.size,
                                               index: kAttributeOmniShadowVertexShaderBufferObjectIndex)
                        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                                index: kAttributeOmniShadowVertexShaderBufferModelUniforms)
                        for pieceIndex in mesh.pieceDescriptions {
                            encoder.setVertexBuffer(dataStore.matrixPalettes.buffer,
                                                    offset: scene.paletteOffset[index],
                                                    index: kAttributeOmniShadowVertexShaderBufferMatrixPalettes)
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
                    if !masks[lightIndex][faceIndex][index] {
                        continue
                    }
                    let object = scene.entities[index].data
                    if object.type == .mesh && scene.skeletonReferences[index] == .nil {
                        let mesh = scene.meshes[object.referenceIdx]
                        encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                                offset: mesh.vertexBuffer.offset,
                                                index: kAttributeOmniShadowVertexShaderBufferStageIn)
                        var mutableIndex = Int32(index)
                        encoder.setVertexBytes(&mutableIndex,
                                               length: MemoryLayout<Int32>.size,
                                               index: kAttributeOmniShadowVertexShaderBufferObjectIndex)
                        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                                index: kAttributeOmniShadowVertexShaderBufferModelUniforms)
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
    private static var rotationMatrices: [simd_float4x4] {
        return [
            simd_quatf.environment.positiveX.rotationMatrix,
            simd_quatf.environment.negativeX.rotationMatrix,
            simd_quatf.environment.positiveY.rotationMatrix,
            simd_quatf.environment.negativeY.rotationMatrix,
            simd_quatf.environment.positiveZ.rotationMatrix,
            simd_quatf.environment.negativeZ.rotationMatrix
        ]
    }
}

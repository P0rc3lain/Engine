//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct OmniShadowRenderer {
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
        var rotations = OmniShadowRenderer.rotationMatrices
        self.rotationsBuffer.upload(data: &rotations)
    }
    private func generateRenderMasks(scene: inout GPUSceneDescription,
                                     arrangement: inout Arrangement) -> [[[Bool]]] {
        let rotations = simd_quatf.environment
        return scene.omniLights.count.naturalExclusive.map { lightIndex in
            var faceData = [[Bool]]()
            for faceIndex in 6.naturalExclusive {
                let entityIndex = Int(scene.omniLights[lightIndex].idx)
                let cameraTransform = arrangement.worldPositions[entityIndex].modelMatrixInverse
                let boundingBox = BoundingBox.projectionBounds(inverseProjection: scene.omniLights[lightIndex].projectionMatrixInverse)
                let cameraBoundingBox = (rotations[faceIndex].rotationMatrix * cameraTransform * boundingBox).aabb
                let mask = CullingController.cullingMask(arrangement: &arrangement,
                                                         worldBoundingBox: cameraBoundingBox)
                faceData.append(mask)
            }
            return faceData
        }
    }
    func draw(encoder: inout MTLRenderCommandEncoder,
              scene: inout GPUSceneDescription,
              dataStore: inout BufferStore,
              arrangement: inout Arrangement) {
        guard !scene.omniLights.isEmpty else {
            return
        }
        let masks = generateRenderMasks(scene: &scene,
                                        arrangement: &arrangement)
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
                        let mesh = scene.meshBuffers[object.referenceIdx]
                        encoder.setVertexBuffer(mesh.buffer,
                                                offset: mesh.offset,
                                                index: kAttributeOmniShadowVertexShaderBufferStageIn)
                        var mutableIndex = Int32(index)
                        encoder.setVertexBytes(&mutableIndex,
                                               length: MemoryLayout<Int32>.size,
                                               index: kAttributeOmniShadowVertexShaderBufferObjectIndex)
                        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                                index: kAttributeOmniShadowVertexShaderBufferModelUniforms)
                        for pieceIndex in scene.indexDrawReferences[object.referenceIdx].indices {
                            encoder.setVertexBuffer(dataStore.matrixPalettes.buffer,
                                                    offset: scene.paletteReferences[index].lowerBound,
                                                    index: kAttributeOmniShadowVertexShaderBufferMatrixPalettes)
                            let indexDraw = scene.pieceDescriptions[pieceIndex].drawDescription
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
                        let mesh = scene.meshBuffers[object.referenceIdx]
                        encoder.setVertexBuffer(mesh.buffer,
                                                offset: mesh.offset,
                                                index: kAttributeOmniShadowVertexShaderBufferStageIn)
                        var mutableIndex = Int32(index)
                        encoder.setVertexBytes(&mutableIndex,
                                               length: MemoryLayout<Int32>.size,
                                               index: kAttributeOmniShadowVertexShaderBufferObjectIndex)
                        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                                index: kAttributeOmniShadowVertexShaderBufferModelUniforms)
                        for pieceIndex in scene.indexDrawReferences[object.referenceIdx].indices {
                            let indexDraw = scene.pieceDescriptions[pieceIndex].drawDescription
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

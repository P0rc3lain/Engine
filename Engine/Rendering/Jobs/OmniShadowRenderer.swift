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
    private var rotationsBuffer: StaticBuffer<simd_float4x4>
    private let viewPort: MTLViewport
    init(pipelineState: MTLRenderPipelineState,
         animatedPipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState,
         rotationsBuffer: StaticBuffer<simd_float4x4>,
         viewPort: MTLViewport) {
        self.pipelineState = pipelineState
        self.animatedPipelineState = animatedPipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = viewPort
        self.rotationsBuffer = rotationsBuffer
        var rotations = OmniShadowRenderer.rotationMatrices
        self.rotationsBuffer.upload(data: &rotations)
    }
    func draw(encoder: inout MTLRenderCommandEncoder,
              scene: inout GPUSceneDescription,
              dataStore: inout BufferStore) {
        guard !scene.omniLights.isEmpty else {
            return
        }
        encoder.setViewport(viewPort)
        encoder.setCullMode(.front)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(rotationsBuffer,
                                index: kAttributeOmniShadowVertexShaderBufferRotations)
        encoder.setVertexBuffer(dataStore.omniLights,
                                index: kAttributeOmniShadowVertexShaderBufferOmniLights)
        for index in scene.entities.indices {
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
                    let indexDraw = scene.indexDraws[pieceIndex]
                    encoder.drawIndexedPrimitives(type: indexDraw.primitiveType,
                                                  indexCount: indexDraw.indexCount,
                                                  indexType: indexDraw.indexType,
                                                  indexBuffer: indexDraw.indexBuffer.buffer,
                                                  indexBufferOffset: indexDraw.indexBuffer.offset,
                                                  instanceCount: scene.omniLights.count * 6)
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
                                        index: kAttributeOmniShadowVertexShaderBufferStageIn)
                var mutableIndex = Int32(index)
                encoder.setVertexBytes(&mutableIndex,
                                       length: MemoryLayout<Int32>.size,
                                       index: kAttributeOmniShadowVertexShaderBufferObjectIndex)
                encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                        index: kAttributeOmniShadowVertexShaderBufferModelUniforms)
                for pieceIndex in scene.indexDrawReferences[object.referenceIdx].indices {
                    let indexDraw = scene.indexDraws[pieceIndex]
                    encoder.drawIndexedPrimitives(type: indexDraw.primitiveType,
                                                  indexCount: indexDraw.indexCount,
                                                  indexType: indexDraw.indexType,
                                                  indexBuffer: indexDraw.indexBuffer.buffer,
                                                  indexBufferOffset: indexDraw.indexBuffer.offset,
                                                  instanceCount: scene.omniLights.count * 6)
                }
            }
        }
    }
    private static var rotationMatrices: [simd_float4x4] {
        var rotations = [simd_float4x4]()
        let xPlus = simd_quatf(angle: Float(180).radians, axis: [0, 0, 1]) * simd_quatf(angle: Float(-90).radians, axis: [0, 1, 0])
        let xMinus = simd_quatf(angle: Float(180).radians, axis: [0, 0, 1]) * simd_quatf(angle: Float(90).radians, axis: [0, 1, 0])
        let yPlus = simd_quatf(angle: Float(90).radians, axis: [1, 0, 0]) * simd_quatf(angle: Float(-180).radians, axis: [0, 0, 1])
        let yMinus = simd_quatf(angle: Float(-90).radians, axis: [1, 0, 0]) * simd_quatf(angle: Float(-180).radians, axis: [0, 0, 1])
        let zPlus = simd_quatf(angle: Float(180).radians, axis: [0, 0, 1])
        let zMinus = simd_quatf(angle: Float(180).radians, axis: [0, 0, 1]) * simd_quatf(angle: Float(180).radians, axis: [0, 1, 0])
        rotations.append(simd_float4x4(xPlus))
        rotations.append(simd_float4x4(xMinus))
        rotations.append(simd_float4x4(yPlus))
        rotations.append(simd_float4x4(yMinus))
        rotations.append(simd_float4x4(zPlus))
        rotations.append(simd_float4x4(zMinus))
        return rotations
    }
}

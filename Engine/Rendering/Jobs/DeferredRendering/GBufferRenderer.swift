//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import MetalKit
import simd

struct GBufferRenderer {
    private let pipelineState: MTLRenderPipelineState
    private let animatedPipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    init(pipelineState: MTLRenderPipelineState,
         animatedPipelineState: MTLRenderPipelineState,
         depthStencilState: MTLDepthStencilState,
         drawableSize: CGSize) {
        self.pipelineState = pipelineState
        self.animatedPipelineState = animatedPipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = .porcelain(size: drawableSize)
    }
    private func generateRenderMask(scene: inout GPUSceneDescription,
                                     arrangement: inout Arrangement) -> [Bool] {
        let cameraTransform = arrangement.worldPositions[scene.activeCameraIdx].modelMatrixInverse
        let cameraIndex = scene.entities[scene.activeCameraIdx].data.referenceIdx
        let cameraBoundingBox = (cameraTransform * scene.cameras[cameraIndex].boundingBox).aabb
        return CullingController.cullingMask(arrangement: &arrangement,
                                             worldBoundingBox: cameraBoundingBox)
    }
    func draw(encoder: inout MTLRenderCommandEncoder,
              scene: inout GPUSceneDescription,
              dataStore: inout BufferStore,
              arrangement: inout Arrangement) {
        let mask = generateRenderMask(scene: &scene, arrangement: &arrangement)
        var boundMaterialIdx = Int.nil
        encoder.setViewport(viewPort)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setCullMode(.back)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setVertexBuffer(dataStore.cameras.buffer,
                                index: kAttributeGBufferVertexShaderBufferCameraUniforms)
        encoder.setStencilReferenceValue(1)
        encoder.setRenderPipelineState(animatedPipelineState)
        let texturesRange = kAttributeGBufferFragmentShaderTextureAlbedo ... kAttributeGBufferFragmentShaderTextureMetallic
        for index in scene.entities.indices {
            let object = scene.entities[index].data
            if object.type == .mesh && scene.skeletonReferences[index] != .nil {
                if !mask[index] {
                    continue
                }
                let mesh = scene.meshBuffers[object.referenceIdx]
                encoder.setVertexBuffer(mesh.buffer,
                                        offset: mesh.offset,
                                        index: kAttributeGBufferVertexShaderBufferStageIn)
                var mutableIndex = Int32(index)
                encoder.setVertexBytes(&mutableIndex,
                                       length: MemoryLayout<Int32>.size,
                                       index: kAttributeGBufferVertexShaderBufferObjectIndex)
                encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                        index: kAttributeGBufferVertexShaderBufferModelUniforms)
                for pieceIndex in scene.indexDrawReferences[object.referenceIdx].indices {
                    encoder.setVertexBuffer(dataStore.matrixPalettes,
                                            offset: scene.paletteReferences[index].lowerBound,
                                            index: kAttributeGBufferVertexShaderBufferMatrixPalettes)
                    let materialIdx = scene.pieceDescriptions[pieceIndex].materialIdx
                    if boundMaterialIdx != materialIdx {
                        let material = scene.materials[materialIdx]
                        encoder.setFragmentTextures([material.albedo,
                                                     material.roughness,
                                                     material.normals,
                                                     material.metallic],
                                                    range: texturesRange)
                        boundMaterialIdx = materialIdx
                    }
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
            let object = scene.entities[index].data
            if object.type == .mesh && scene.skeletonReferences[index] == .nil {
                if !mask[index] {
                    continue
                }
                let mesh = scene.meshBuffers[object.referenceIdx]
                encoder.setVertexBuffer(mesh.buffer,
                                        offset: mesh.offset,
                                        index: kAttributeGBufferVertexShaderBufferStageIn)
                var mutableIndex = Int32(index)
                encoder.setVertexBytes(&mutableIndex,
                                       length: MemoryLayout<Int32>.size,
                                       index: kAttributeGBufferVertexShaderBufferObjectIndex)
                encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                        index: kAttributeGBufferVertexShaderBufferModelUniforms)
                for pieceIndex in scene.indexDrawReferences[object.referenceIdx].indices {
                    let materialIdx = scene.pieceDescriptions[pieceIndex].materialIdx
                    if boundMaterialIdx != materialIdx {
                        let material = scene.materials[materialIdx]
                        encoder.setFragmentTextures([material.albedo,
                                                     material.roughness,
                                                     material.normals,
                                                     material.metallic],
                                                    range: texturesRange)
                        boundMaterialIdx = materialIdx
                    }
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

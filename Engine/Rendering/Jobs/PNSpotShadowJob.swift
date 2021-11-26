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
    private func generateRenderMasks(scene: PNSceneDescription) -> [[Bool]] {
        return scene.spotLights.count.naturalExclusive.map { i in
            let cameraTransform = scene.uniforms[Int(scene.spotLights[i].idx)].modelMatrixInverse
            let interactor = PNIBoundingBoxInteractor(boundInteractor: PNIBoundInteractor())
            let cullingController = PNICullingController(interactor: interactor)
            let cameraBoundingBox = interactor.multiply(cameraTransform, scene.spotLights[i].boundingBox)
            let cameraAlignedBoundingBox = interactor.aabb(cameraBoundingBox)
            let mask = cullingController.cullingMask(scene: scene,
                                                     boundingBox: cameraAlignedBoundingBox)
            return mask
        }
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
        let masks = generateRenderMasks(scene: scene)
        for lightIndex in scene.spotLights.count.naturalExclusive {
            var lIndex = lightIndex
            encoder.setVertexBytes(&lIndex,
                                   length: MemoryLayout<Int>.size,
                                   index: kAttributeSpotShadowVertexShaderBufferInstanceId)
            for index in scene.entities.indices {
                if !masks[lightIndex][index] {
                    continue
                }
                let object = scene.entities[index].data
                if object.type == .mesh && scene.skeletonReferences[index] != .nil {
                    let mesh = scene.meshes[object.referenceIdx]
                    encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                            offset: mesh.vertexBuffer.offset,
                                            index: kAttributeSpotShadowVertexShaderBufferStageIn)
                    var mutableIndex = Int32(index)
                    encoder.setVertexBytes(&mutableIndex,
                                           length: MemoryLayout<Int32>.size,
                                           index: kAttributeSpotShadowVertexShaderBufferObjectIndex)
                    encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                            index: kAttributeSpotShadowVertexShaderBufferModelUniforms)
                    for pieceIndex in mesh.pieceDescriptions {
                        encoder.setVertexBuffer(dataStore.matrixPalettes.buffer,
                                                offset: scene.paletteOffset[index],
                                                index: kAttributeSpotShadowVertexShaderBufferMatrixPalettes)
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
                if !masks[lightIndex][index] {
                    continue
                }
                let object = scene.entities[index].data
                if object.type == .mesh && scene.skeletonReferences[index] == .nil {
                    let mesh = scene.meshes[object.referenceIdx]
                    encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                            offset: mesh.vertexBuffer.buffer.offset,
                                            index: kAttributeSpotShadowVertexShaderBufferStageIn)
                    var mutableIndex = Int32(index)
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
}

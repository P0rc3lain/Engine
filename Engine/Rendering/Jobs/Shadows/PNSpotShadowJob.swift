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
        encoder.setDepthStencilState(depthStencilState)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(dataStore.spotLights,
                                index: kAttributeSpotShadowVertexShaderBufferSpotLights)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                index: kAttributeSpotShadowVertexShaderBufferModelUniforms)
        let masks = supply.mask.spotLights
        for lightIndex in scene.spotLights.count.naturalExclusive {
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
                encoder.setVertexBytes(value: Int32(animatedModel.idx),
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
    static func make(device: MTLDevice,
                     renderingSize: CGSize) -> PNSpotShadowJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSSpotShadow(library: library),
              let depthStencilState = device.makeDSSSpotShadow(),
              let animatedPipelineState = device.makeRPSSpotShadowAnimated(library: library) else {
            return nil
        }
        return PNSpotShadowJob(pipelineState: pipelineState,
                               animatedPipelineState: animatedPipelineState,
                               depthStencilState: depthStencilState,
                               viewPort: .porcelain(size: renderingSize))
    }
}

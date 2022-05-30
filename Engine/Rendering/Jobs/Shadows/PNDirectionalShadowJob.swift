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
        encoder.setDepthStencilState(depthStencilState)
        encoder.setRenderPipelineState(animatedPipelineState)
        encoder.setVertexBuffer(dataStore.directionalLights,
                                index: kAttributeDirectionalShadowVertexShaderBufferDirectionalLights)
        encoder.setVertexBuffer(dataStore.modelCoordinateSystems,
                                index: kAttributeDirectionalShadowVertexShaderBufferModelUniforms)
        for lightIndex in scene.directionalLights.count.naturalExclusive {
            encoder.setVertexBytes(value: lightIndex,
                                   index: kAttributeDirectionalShadowVertexShaderBufferInstanceId)
            for animatedModel in scene.animatedModels {
                encoder.setVertexBuffer(dataStore.matrixPalettes.buffer,
                                        offset: scene.paletteOffset[animatedModel.skeleton],
                                        index: kAttributeDirectionalShadowVertexShaderBufferMatrixPalettes)
                draw(encoder: encoder,
                     mesh: scene.meshes[animatedModel.mesh],
                     uniformReference: animatedModel.idx)
            }
        }
        encoder.setRenderPipelineState(pipelineState)
        for lightIndex in scene.directionalLights.count.naturalExclusive {
            encoder.setVertexBytes(value: lightIndex,
                                   index: kAttributeDirectionalShadowVertexShaderBufferInstanceId)
            for model in scene.models {
                draw(encoder: encoder,
                     mesh: scene.meshes[model.mesh],
                     uniformReference: model.idx)
            }
        }
    }
    private func draw(encoder: MTLRenderCommandEncoder, mesh: PNMesh, uniformReference: PNIndex) {
        encoder.setFrontCulling(mesh.culling)
        encoder.setVertexBuffer(mesh.vertexBuffer.buffer,
                                offset: mesh.vertexBuffer.buffer.offset,
                                index: kAttributeDirectionalShadowVertexShaderBufferStageIn)
        encoder.setVertexBytes(value: Int32(uniformReference),
                               index: kAttributeDirectionalShadowVertexShaderBufferObjectIndex)
        for pieceDescription in mesh.pieceDescriptions {
            encoder.drawIndexedPrimitives(submesh: pieceDescription.drawDescription)
        }
    }
    static func make(device: MTLDevice,
                     renderingSize: CGSize) -> PNDirectionalShadowJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSDirectionalShadow(library: library),
              let depthStencilState = device.makeDSSDirectionalLightShadow(),
              let animatedPipelineState = device.makeRPSDirectionalShadowAnimated(library: library) else {
            return nil
        }
        return PNDirectionalShadowJob(pipelineState: pipelineState,
                                      animatedPipelineState: animatedPipelineState,
                                      depthStencilState: depthStencilState,
                                      viewPort: .porcelain(size: renderingSize))
    }
}

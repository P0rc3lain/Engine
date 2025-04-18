//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared

struct PNAmbientJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let inputTextures: [PNTextureProvider]
    private let ssaoTexture: PNTextureProvider
    private let plane: PNMesh
    init?(pipelineState: MTLRenderPipelineState,
          inputTextures: [PNTextureProvider],
          ssaoTexture: PNTextureProvider,
          device: MTLDevice,
          depthStencilState: MTLDepthStencilState) {
        guard let plane = PNMesh.plane(device: device) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.inputTextures = inputTextures
        self.ssaoTexture = ssaoTexture
        self.plane = plane
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let scene = supply.scene
        let bufferStore = supply.bufferStore
        guard !scene.ambientLights.isEmpty else {
            return
        }
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setStencilReferenceValue(1)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeAmbientVertexShaderBufferStageIn)
        encoder.setFragmentBuffer(bufferStore.modelCoordinateSystems,
                                  index: kAttributeAmbientFragmentShaderBufferModelUniforms)
        let cameraIdx = scene.entities[scene.activeCameraIdx].data.referenceIdx
        encoder.setFragmentBuffer(bufferStore.cameras,
                                  offset: cameraIdx * MemoryLayout<CameraUniforms>.stride,
                                  index: kAttributeAmbientFragmentShaderBufferCamera)
        encoder.setFragmentBuffer(bufferStore.ambientLights,
                                  index: kAttributeAmbientFragmentShaderBufferAmbientLights)
        encoder.setFragmentTexture(ssaoTexture, index: kAttributeAmbientFragmentShaderTextureSSAO)
        encoder.setFragmentTexture(inputTextures[0], index: kAttributeAmbientFragmentShaderTextureAR)
        encoder.setFragmentTexture(inputTextures[2], index: kAttributeAmbientFragmentShaderTexturePR)
        encoder.drawIndexedPrimitives(submesh: plane.pieceDescriptions[0].drawDescription,
                                      instanceCount: scene.ambientLights.count)
    }
    static func make(device: MTLDevice,
                     inputTextures: [PNTextureProvider],
                     ssaoTexture: PNTextureProvider) -> PNAmbientJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRPSAmbient(library: library)
        let depthStencilState = device.makeDSSAmbient()
        return PNAmbientJob(pipelineState: pipelineState,
                            inputTextures: inputTextures,
                            ssaoTexture: ssaoTexture,
                            device: device,
                            depthStencilState: depthStencilState)
    }
}

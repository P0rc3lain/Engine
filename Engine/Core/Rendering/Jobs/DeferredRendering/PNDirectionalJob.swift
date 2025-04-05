//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import simd

struct PNDirectionalJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let inputTextures: [PNTextureProvider]
    private let shadowMap: PNTextureProvider
    private let plane: PNMesh
    init?(pipelineState: MTLRenderPipelineState,
          inputTextures: [PNTextureProvider],
          shadowMap: PNTextureProvider,
          device: MTLDevice,
          depthStencilState: MTLDepthStencilState) {
        guard let plane = PNMesh.plane(device: device) else {
            return nil
        }
        self.shadowMap = shadowMap
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.inputTextures = inputTextures
        self.plane = plane
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let scene = supply.scene
        let bufferStore = supply.bufferStore
        guard !scene.directionalLights.isEmpty else {
            return
        }
        let arTexture = inputTextures[0]
        let nmTexture = inputTextures[1]
        let prTexture = inputTextures[2]
        encoder.setRenderPipelineState(pipelineState)
        encoder.setStencilReferenceValue(1)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeDirectionalVertexShaderBufferStageIn)
        encoder.setFragmentBuffer(bufferStore.directionalLights,
                                  index: kAttributeDirectionalFragmentShaderBufferDirectionalLights)
        let cameraIdx = scene.entities[scene.activeCameraIdx].data.referenceIdx
        encoder.setFragmentBuffer(bufferStore.cameras,
                                  offset: cameraIdx * MemoryLayout<CameraUniforms>.stride,
                                  index: kAttributeDirectionalFragmentShaderBufferCamera)
        encoder.setFragmentBuffer(bufferStore.modelCoordinateSystems,
                                  index: kAttributeDirectionalFragmentShaderBufferLightUniforms)
        let range = kAttributeDirectionalFragmentShaderTextureAR ... kAttributeDirectionalFragmentShaderTextureShadowMaps
        encoder.setFragmentTextures([arTexture, nmTexture, prTexture, shadowMap], range: range)
        encoder.drawIndexedPrimitives(submesh: plane.pieceDescriptions[0].drawDescription,
                                      instanceCount: scene.directionalLights.count)
    }
    static func make(device: MTLDevice,
                     inputTextures: [PNTextureProvider],
                     shadowMap: PNTextureProvider) -> PNDirectionalJob? {
        let library = device.makePorcelainLibrary()
        let pipelineState = device.makeRPSDirectional(library: library)
        let depthStencilState = device.makeDSSDirectional()
        return PNDirectionalJob(pipelineState: pipelineState,
                                inputTextures: inputTextures,
                                shadowMap: shadowMap,
                                device: device,
                                depthStencilState: depthStencilState)
    }
}

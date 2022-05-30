//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import MetalKit
import simd

struct PNSpotJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    private let inputTextures: [MTLTexture]
    private let shadowMap: MTLTexture
    private let plane: PNMesh
    init?(pipelineState: MTLRenderPipelineState,
          inputTextures: [MTLTexture],
          shadowMap: MTLTexture,
          device: MTLDevice,
          depthStencilState: MTLDepthStencilState,
          drawableSize: CGSize) {
        guard let plane = PNMesh.screenSpacePlane(device: device) else {
            return nil
        }
        self.shadowMap = shadowMap
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.inputTextures = inputTextures
        self.plane = plane
        self.viewPort = .porcelain(size: drawableSize)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let scene = supply.scene
        let bufferStore = supply.bufferStore
        guard !scene.spotLights.isEmpty else {
            return
        }
        let arTexture = inputTextures[0]
        let nmTexture = inputTextures[1]
        let prTexture = inputTextures[2]
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeSpotVertexShaderBufferStageIn)
        encoder.setFragmentBuffer(bufferStore.spotLights,
                                  index: kAttributeSpotFragmentShaderBufferSpotLights)
        let cameraIdx = scene.entities[scene.activeCameraIdx].data.referenceIdx
        encoder.setFragmentBuffer(bufferStore.cameras,
                                  offset: cameraIdx * MemoryLayout<CameraUniforms>.stride,
                                  index: kAttributeSpotFragmentShaderBufferCamera)
        encoder.setFragmentBuffer(bufferStore.modelCoordinateSystems,
                                  index: kAttributeSpotFragmentShaderBufferModelUniforms)
        let range = kAttributeSpotFragmentShaderTextureAR ... kAttributeSpotFragmentShaderTextureShadowMaps
        encoder.setFragmentTextures([arTexture, nmTexture, prTexture, shadowMap], range: range)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset,
                                      instanceCount: scene.spotLights.count)
    }
    static func make(device: MTLDevice,
                     inputTextures: [MTLTexture],
                     shadowMap: MTLTexture,
                     drawableSize: CGSize) -> PNSpotJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSSpot(library: library),
              let depthStencilState = device.makeDepthStencilStateSpotPass() else {
            return nil
        }
        return PNSpotJob(pipelineState: pipelineState,
                         inputTextures: inputTextures,
                         shadowMap: shadowMap,
                         device: device,
                         depthStencilState: depthStencilState,
                         drawableSize: drawableSize)
    }
}

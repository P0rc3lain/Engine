//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import MetalKit
import simd

struct PNOmniJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    private let inputTextures: [PNTextureProvider]
    private let shadowMaps: PNTextureProvider
    private let plane: PNMesh
    init?(pipelineState: MTLRenderPipelineState,
          inputTextures: [PNTextureProvider],
          shadowMaps: PNTextureProvider,
          device: MTLDevice,
          depthStencilState: MTLDepthStencilState,
          drawableSize: CGSize) {
        guard let plane = PNMesh.plane(device: device) else {
            return nil
        }
        self.shadowMaps = shadowMaps
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.inputTextures = inputTextures
        self.plane = plane
        self.viewPort = .porcelain(size: drawableSize)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        let scene = supply.scene
        let bufferStore = supply.bufferStore
        guard !scene.omniLights.isEmpty else {
            return
        }
        let arTexture = inputTextures[0]
        let nmTexture = inputTextures[1]
        let prTexture = inputTextures[2]
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeLightingVertexShaderBufferStageIn)
        encoder.setFragmentBuffer(bufferStore.omniLights,
                                  index: kAttributeLightingFragmentShaderBufferOmniLights)
        let cameraIdx = scene.entities[scene.activeCameraIdx].data.referenceIdx
        encoder.setFragmentBuffer(bufferStore.cameras,
                                  offset: cameraIdx * MemoryLayout<CameraUniforms>.stride,
                                  index: kAttributeLightingFragmentShaderBufferCamera)
        encoder.setFragmentBuffer(bufferStore.modelCoordinateSystems,
                                  index: kAttributeLightingFragmentShaderBufferLightUniforms)
        encoder.setFragmentTextures([arTexture, nmTexture, prTexture, shadowMaps],
                                    range: kAttributeLightingFragmentShaderTextureAR ... kAttributeLightingFragmentShaderTextureShadowMaps)
        encoder.drawIndexedPrimitives(submesh: plane.pieceDescriptions[0].drawDescription,
                                      instanceCount: scene.omniLights.count)
    }
    static func make(device: MTLDevice,
                     inputTextures: [PNTextureProvider],
                     shadowMaps: PNTextureProvider,
                     drawableSize: CGSize) -> PNOmniJob? {
        guard let library = device.makePorcelainLibrary(),
              let pipelineState = device.makeRPSOmni(library: library),
              let depthStencilState = device.makeDSSOmni() else {
            return nil
        }
        return PNOmniJob(pipelineState: pipelineState,
                         inputTextures: inputTextures,
                         shadowMaps: shadowMaps,
                         device: device,
                         depthStencilState: depthStencilState,
                         drawableSize: drawableSize)
    }
}

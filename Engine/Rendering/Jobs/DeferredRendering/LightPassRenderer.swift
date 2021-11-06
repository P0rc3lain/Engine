//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import MetalBinding
import MetalKit
import simd

struct OmniRenderer {
    let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    private let inputTextures: [MTLTexture]
    private let plane: GPUGeometry
    init?(pipelineState: MTLRenderPipelineState,
          inputTextures: [MTLTexture],
          device: MTLDevice,
          depthStencilState: MTLDepthStencilState,
          drawableSize: CGSize) {
        guard let plane = GPUGeometry.screenSpacePlane(device: device) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.inputTextures = inputTextures
        self.plane = plane
        self.viewPort = .porcelain(size: drawableSize)
    }
    func draw(encoder: inout MTLRenderCommandEncoder,
              bufferStore: inout BufferStore,
              lightsCount: Int,
              scene: inout GPUSceneDescription) {
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
        let range = kAttributeLightingFragmentShaderTextureAR ... kAttributeLightingFragmentShaderTexturePR
        encoder.setFragmentTextures([arTexture, nmTexture, prTexture], range: range)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset,
                                      instanceCount: lightsCount)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding

struct AmbientRenderer {
    let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    private let inputTextures: [MTLTexture]
    private let plane: PNGPUMesh
    init?(pipelineState: MTLRenderPipelineState,
          inputTextures: [MTLTexture],
          device: MTLDevice,
          depthStencilState: MTLDepthStencilState,
          drawableSize: CGSize) {
        guard let plane = PNGPUMesh.screenSpacePlane(device: device) else {
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
              ssao: MTLTexture,
              scene: inout GPUSceneDescription) {
        guard !scene.ambientLights.isEmpty else {
            return
        }
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
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
        encoder.setFragmentTexture(ssao, index: kAttributeAmbientFragmentShaderTextureSSAO)
        encoder.setFragmentTexture(inputTextures[0], index: kAttributeAmbientFragmentShaderTextureAR)
        encoder.setFragmentTexture(inputTextures[2], index: kAttributeAmbientFragmentShaderTexturePR)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset,
                                      instanceCount: scene.ambientLights.count)
    }
}

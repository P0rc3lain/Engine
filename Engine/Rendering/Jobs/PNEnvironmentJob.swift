//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct PNEnvironmentJob: PNRenderJob {
    private let pipelineState: MTLRenderPipelineState
    private let depthStentilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    private let cube: PNMesh
    init(pipelineState: MTLRenderPipelineState,
         depthStentilState: MTLDepthStencilState,
         drawableSize: CGSize,
         cube: PNMesh) {
        self.pipelineState = pipelineState
        self.depthStentilState = depthStentilState
        self.cube = cube
        self.viewPort = .porcelain(size: drawableSize)
    }
    func draw(encoder: MTLRenderCommandEncoder, supply: PNFrameSupply) {
        guard let skyMap = supply.scene.skyMap else {
            return
        }
        encoder.setViewport(viewPort)
        encoder.setStencilReferenceValue(0)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStentilState)
        encoder.setVertexBuffer(cube.vertexBuffer.buffer,
                                index: kAttributeEnvironmentVertexShaderBufferStageIn)
        encoder.setVertexBuffer(supply.bufferStore.modelCoordinateSystems,
                                index: kAttributeEnvironmentVertexShaderBufferModelUniforms)
        encoder.setVertexBuffer(supply.bufferStore.cameras,
                                offset: supply.scene.entities[supply.scene.activeCameraIdx].data.referenceIdx * MemoryLayout<CameraUniforms>.stride,
                                index: kAttributeEnvironmentVertexShaderBufferCamera)
        encoder.setFragmentTexture(skyMap,
                                   index: kAttributeEnvironmentFragmentShaderTextureCubeMap)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: cube.pieceDescriptions[0].drawDescription.indexBuffer.length / MemoryLayout<UInt16>.size,
                                      indexType: .uint16,
                                      indexBuffer: cube.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: 0)
    }
}
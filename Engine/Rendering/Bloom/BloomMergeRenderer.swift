//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import MetalPerformanceShaders
import simd

struct BloomMergeRenderer {
    private let pipelineState: MTLRenderPipelineState
    private let viewPort: MTLViewport
    private let plane: GPUGeometry
    init?(pipelineState: MTLRenderPipelineState,
          device: MTLDevice,
          drawableSize: CGSize) {
        guard let plane = GPUGeometry.screenSpacePlane(device: device) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.plane = plane
        self.viewPort = .porcelain(size: drawableSize)
    }
    mutating func draw(encoder: inout MTLRenderCommandEncoder, renderPass: inout MTLRenderPassDescriptor, brightAreasTexture: MTLTexture) {
        guard let unmodifiedSceneTexture = renderPass.colorAttachments[0].texture else {
            return
        }
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributeBloomSplitVertexShaderBufferStageIn)
        encoder.setFragmentTexture(unmodifiedSceneTexture, index: kAttributeBloomMergeFragmentShaderTextureOriginal)
        encoder.setFragmentTexture(brightAreasTexture, index: kAttributeBloomMergeFragmentShaderTextureBrightAreas)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset)
    }
}

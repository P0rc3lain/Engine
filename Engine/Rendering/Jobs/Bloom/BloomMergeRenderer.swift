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
    private let plane: PNMesh
    init?(pipelineState: MTLRenderPipelineState,
          device: MTLDevice,
          drawableSize: CGSize) {
        guard let plane = PNMesh.screenSpacePlane(device: device) else {
            return nil
        }
        self.pipelineState = pipelineState
        self.plane = plane
        self.viewPort = .porcelain(size: drawableSize)
    }
    mutating func draw(encoder: inout MTLRenderCommandEncoder,
                       unmodifiedSceneTexture: MTLTexture,
                       brightAreasTexture: MTLTexture) {
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

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct Postprocessor {
    private let pipelineState: MTLRenderPipelineState
    private let inputTexture: MTLTexture
    private let viewPort: MTLViewport
    private let plane: GPUGeometry
    init(pipelineState: MTLRenderPipelineState,
         inputTexture: MTLTexture,
         plane: GPUGeometry,
         canvasSize: CGSize) {
        self.inputTexture = inputTexture
        self.pipelineState = pipelineState
        self.plane = plane
        self.viewPort = .porcelain(size: canvasSize)
    }
    func draw(encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentTexture(inputTexture,
                                   index: kAttributePostprocessingFragmentShaderTexture)
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributePostprocessingVertexShaderBufferStageIn)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset)
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import simd

struct Postprocessor {
    private let pipelineState: MTLRenderPipelineState
    private let texture: MTLTexture
    private let viewPort: MTLViewport
    private let plane: GPUGeometry
    init(pipelineState: MTLRenderPipelineState, texture: MTLTexture, plane: GPUGeometry, canvasSize: CGSize) {
        self.texture = texture
        self.pipelineState = pipelineState
        self.plane = plane
        self.viewPort = .porcelain(size: canvasSize)
    }
    func draw(encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentTexture(texture, index: kAttributePostprocessingFragmentShaderTexture.int)
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer,
                                index: kAttributePostprocessingVertexShaderBufferStageIn.int)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.pieceDescriptions[0].drawDescription.indexCount,
                                      indexType: plane.pieceDescriptions[0].drawDescription.indexType,
                                      indexBuffer: plane.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: plane.pieceDescriptions[0].drawDescription.indexBuffer.offset)
    }
}

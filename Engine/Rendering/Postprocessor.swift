//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import simd
import Metal
import MetalBinding

struct Postprocessor {
    // MARK: - Properties
    private let pipelineState: MTLRenderPipelineState
    private let texture: MTLTexture
    private let viewPort: MTLViewport
    private let plane: GPUGeometry
    // MARK: - Initialization
    init(pipelineState: MTLRenderPipelineState, texture: MTLTexture, plane: GPUGeometry, canvasSize: CGSize) {
        self.texture = texture
        self.pipelineState = pipelineState
        self.plane = plane
        self.viewPort = .porcelain(size: canvasSize)
    }
    // MARK: - Internal
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

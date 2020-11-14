//
//  Postprocessor.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import simd
import Metal

struct Postprocessor {
    // MARK: - Properties
    private let pipelineState: MTLRenderPipelineState
    private let texture: MTLTexture
    private let viewPort: MTLViewport
    private let plane: Geometry
    // MARK: - Initialization
    init(pipelineState: MTLRenderPipelineState, texture: MTLTexture, plane: Geometry) {
        self.texture = texture
        self.pipelineState = pipelineState
        self.plane = plane
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(texture.width), height: Double(texture.height),
                                    znear: 0, zfar: 1)
    }
    // MARK: - Internal
    func draw(encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentTexture(texture, index: 0)
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(plane.vertexBuffer.buffer, offset: 0, index: 0)
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: plane.drawDescription[0].indexCount,
                                      indexType: plane.drawDescription[0].indexType,
                                      indexBuffer: plane.drawDescription[0].indexBuffer.buffer,
                                      indexBufferOffset: plane.drawDescription[0].indexBuffer.offset)
    }
}

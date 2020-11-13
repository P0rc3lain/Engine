//
//  ForwardRenderer.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import simd
import MetalKit
import ShaderTypes

struct ForwardRenderer {
    // MARK: - Properties
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    // MARK: - Initialization
    init(pipelineState: MTLRenderPipelineState, depthStencilState: MTLDepthStencilState, drawableSize: CGSize) {
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(drawableSize.width), height: Double(drawableSize.height),
                                    znear: 0, zfar: 1)
    }
    // MARK: - Internal
    func draw(encoder: inout MTLRenderCommandEncoder, scene: inout Scene, lightsBuffer: inout MTLBuffer) {
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setCullMode(.back)
        encoder.setFrontFacing(.counterClockwise)
        encoder.setFragmentBuffer(lightsBuffer, offset: 0, index: 2)
        for piece in scene.models {
            var transformation = piece.coordinateSpace.transformationTRS
            setupUniforms(encoder: &encoder,
                          scene: &scene,
                          transformation: &transformation)
            encoder.setVertexBuffer(piece.modelPiece.geometry.vertexBuffer.buffer,
                                    offset: piece.modelPiece.geometry.vertexBuffer.offset, index: 0)
            encoder.setFragmentTexture(piece.modelPiece.material.albedo, index: 0)
            encoder.setFragmentTexture(piece.modelPiece.material.roughness, index: 1)
            encoder.setFragmentTexture(piece.modelPiece.material.emission, index: 2)
            encoder.setFragmentTexture(piece.modelPiece.material.normals, index: 3)
            encoder.setFragmentTexture(piece.modelPiece.material.metallic, index: 4)
            for description in piece.modelPiece.geometry.drawDescription {
                encoder.drawIndexedPrimitives(type: description.primitiveType,
                                              indexCount: description.indexCount,
                                              indexType: description.indexType,
                                              indexBuffer: description.indexBuffer.buffer,
                                              indexBufferOffset: description.indexBuffer.offset)
            }
        }
    }
    func setupUniforms(encoder: inout MTLRenderCommandEncoder,
                       scene: inout Scene,
                       transformation: inout simd_float4x4) {
        let lightsCount = Int32(scene.omniLights.count)
        let viewTransformation = scene.camera.coordinateSpace.transformationRTS
        let uniforms = FRUniforms(projectionMatrix: scene.camera.projectionMatrix,
                                  viewMatrix: viewTransformation,
                                  viewMatrixInverse: viewTransformation.inverse,
                                  modelMatrix: transformation,
                                  modelMatrixInverse: transformation.inverse,
                                  omniLightsCount: lightsCount)
        withUnsafePointer(to: uniforms) { ptr in
            encoder.setVertexBytes(ptr, length: MemoryLayout<FRUniforms>.stride, index: 1)
        }
        withUnsafePointer(to: uniforms) { ptr in
            encoder.setFragmentBytes(ptr, length: MemoryLayout<FRUniforms>.stride, index: 1)
        }
    }
}

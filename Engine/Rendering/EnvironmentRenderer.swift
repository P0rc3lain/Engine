//
//  EnvironmentRenderer.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import simd
import Metal

fileprivate struct Uniforms {
    let projectionMatrix: matrix_float4x4
    let orientation: matrix_float4x4
}

struct EnvironmentRenderer {
    // MARK: - Properties
    private let pipelineState: MTLRenderPipelineState
    private let depthStentilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    private let cube: Geometry
    // MARK: - Initialization
    init(pipelineState: MTLRenderPipelineState, depthStentilState: MTLDepthStencilState, drawableSize: CGSize, cube: Geometry) {
        self.pipelineState = pipelineState
        self.depthStentilState = depthStentilState
        self.cube = cube
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(drawableSize.width), height: Double(drawableSize.height),
                                    znear: 0, zfar: 1)
    }
    // MARK: - Internal
    func draw(encoder: MTLRenderCommandEncoder, scene: inout Scene) {
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(cube.vertexBuffer.buffer, offset: 0, index: 0)
        encoder.setDepthStencilState(depthStentilState)
        encoder.setStencilReferenceValue(0)
        encoder.setFragmentTexture(scene.sceneAsset.environment, index: 0)
        let uniforms = Uniforms(projectionMatrix: scene.camera.projectionMatrix,
                                orientation: simd_matrix4x4(scene.camera.coordinateSpace.orientation))
        withUnsafePointer(to: uniforms) { ptr in
            encoder.setVertexBytes(ptr, length: MemoryLayout<Uniforms>.size, index: 1)
        }
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: cube.drawDescription[0].indexBuffer.length / MemoryLayout<UInt16>.size,
                                      indexType: .uint16,
                                      indexBuffer: cube.drawDescription[0].indexBuffer.buffer,
                                      indexBufferOffset: 0)
    }
}

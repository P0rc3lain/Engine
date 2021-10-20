//
//  EnvironmentRenderer.swift
//  Engine
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
    private let cube: GPUGeometry
    // MARK: - Initialization
    init(pipelineState: MTLRenderPipelineState,
         depthStentilState: MTLDepthStencilState,
         drawableSize: CGSize,
         cube: GPUGeometry) {
        self.pipelineState = pipelineState
        self.depthStentilState = depthStentilState
        self.cube = cube
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(drawableSize.width), height: Double(drawableSize.height),
                                    znear: 0, zfar: 1)
    }
    // MARK: - Internal
    func draw(encoder: inout MTLRenderCommandEncoder, scene: inout GPUSceneDescription) {
        if scene.sky == .nil {
            return
        }
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(cube.vertexBuffer.buffer, offset: 0, index: 0)
        encoder.setDepthStencilState(depthStentilState)
        encoder.setStencilReferenceValue(0)
        encoder.setFragmentTexture(scene.skyMaps[scene.sky], index: 0)
        let cameraIndex = scene.objects.objects[scene.activeCameraIdx].data.referenceIdx
        let uniforms = Uniforms(projectionMatrix: scene.cameras[cameraIndex].projectionMatrix,
                                orientation: simd_matrix4x4(scene.objects.objects[scene.activeCameraIdx].data.transform.rotation.interpolated(at: 0)))
        withUnsafePointer(to: uniforms) { ptr in
            encoder.setVertexBytes(ptr, length: MemoryLayout<Uniforms>.size, index: 1)
        }
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: cube.pieceDescriptions[0].drawDescription.indexBuffer.length / MemoryLayout<UInt16>.size,
                                      indexType: .uint16,
                                      indexBuffer: cube.pieceDescriptions[0].drawDescription.indexBuffer.buffer,
                                      indexBufferOffset: 0)
    }
}

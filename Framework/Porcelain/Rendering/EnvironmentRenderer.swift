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
    let translation: simd_float3
    let scale: simd_float3
}

internal struct EnvironmentRenderer {
    private let pipelineState: MTLRenderPipelineState
    private let viewPort: MTLViewport
    internal init(pipelineState: MTLRenderPipelineState, drawableSize: CGSize) {
        self.pipelineState = pipelineState
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(drawableSize.width), height: Double(drawableSize.height),
                                    znear: 0, zfar: 1)
    }
    internal func draw(encoder: MTLRenderCommandEncoder, camera: Camera, vertexBuffer: MTLBuffer, indicesBuffer: MTLBuffer, environmentMap: MTLTexture) {
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setFragmentTexture(environmentMap, index: 0)
        let uniforms = Uniforms(projectionMatrix: camera.projectionMatrix,
                                orientation: simd_matrix4x4(camera.coordinateSpace.orientation),
                                translation: camera.coordinateSpace.translation,
                                scale: camera.coordinateSpace.scale)
        withUnsafePointer(to: uniforms) { ptr in
            encoder.setVertexBytes(ptr, length: MemoryLayout<Uniforms>.size, index: 1)
        }
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: indicesBuffer.length / MemoryLayout<UInt16>.size,
                                      indexType: .uint16,
                                      indexBuffer: indicesBuffer,
                                      indexBufferOffset: 0)
    }
    internal static func buildEnvironmentRenderPipelineState(device: MTLDevice,
                                                               library: MTLLibrary,
                                                               pixelFormat: MTLPixelFormat) -> MTLRenderPipelineState {
        let vertexShader = library.makeFunction(name: "environmentVertexShader")
        let fragmentShader = library.makeFunction(name: "environmentFragmentShader")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexShader
        pipelineDescriptor.fragmentFunction = fragmentShader
        pipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        let vertexDescriptor = MTLVertexDescriptor()
        let layout = MTLVertexBufferLayoutDescriptor()
        layout.stepFunction = .perVertex
        layout.stride = MemoryLayout<SIMD4<Float>>.stride * 2
        layout.stepRate = 1
        vertexDescriptor.layouts[0] = layout
        vertexDescriptor.attributes[0].format = .float4
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = 16
        vertexDescriptor.attributes[1].bufferIndex = 0
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        return try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
}

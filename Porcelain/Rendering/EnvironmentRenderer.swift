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
    private let pipelineState: MTLRenderPipelineState
    private let viewPort: MTLViewport
    private let cube: Geometry
    init(pipelineState: MTLRenderPipelineState, drawableSize: CGSize, cube: Geometry) {
        self.pipelineState = pipelineState
        self.cube = cube
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(drawableSize.width), height: Double(drawableSize.height),
                                    znear: 0, zfar: 1)
    }
    func draw(encoder: MTLRenderCommandEncoder, camera: inout Camera, environmentMap: inout MTLTexture) {
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setVertexBuffer(cube.vertexBuffer.buffer, offset: 0, index: 0)
        encoder.setFragmentTexture(environmentMap, index: 0)
        let uniforms = Uniforms(projectionMatrix: camera.projectionMatrix,
                                orientation: simd_matrix4x4(camera.coordinateSpace.orientation))
        withUnsafePointer(to: uniforms) { ptr in
            encoder.setVertexBytes(ptr, length: MemoryLayout<Uniforms>.size, index: 1)
        }
        encoder.drawIndexedPrimitives(type: .triangle,
                                      indexCount: cube.drawDescription[0].indexBuffer.length / MemoryLayout<UInt16>.size,
                                      indexType: .uint16,
                                      indexBuffer: cube.drawDescription[0].indexBuffer.buffer,
                                      indexBufferOffset: 0)
    }
    static func buildEnvironmentRenderPipelineState(device: MTLDevice,
                                                    library: MTLLibrary,
                                                    pixelFormat: MTLPixelFormat) -> MTLRenderPipelineState {
        let vertexShader = library.makeFunction(name: "environmentVertexShader")
        let fragmentShader = library.makeFunction(name: "environmentFragmentShader")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexShader
        pipelineDescriptor.fragmentFunction = fragmentShader
        pipelineDescriptor.colorAttachments[0].pixelFormat = .rgba32Float
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        let vertexDescriptor = MTLVertexDescriptor()
        let layout = MTLVertexBufferLayoutDescriptor()
        layout.stepFunction = .perVertex
        layout.stride = MemoryLayout<SIMD4<Float>>.stride
        layout.stepRate = 1
        vertexDescriptor.layouts[0] = layout
        vertexDescriptor.attributes[0].format = .float4
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        return try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
}

//
//  Postprocessor.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import simd
import Metal

fileprivate struct Sample {
    let position: vector_float2
    let uv_coordinate: vector_float2
}

fileprivate let coordinates = [Sample(position: vector_float2(-1, -1), uv_coordinate: vector_float2(0, 1)),
                               Sample(position: vector_float2(-1, 1), uv_coordinate: vector_float2(0, 0)),
                               Sample(position: vector_float2(1, 1), uv_coordinate: vector_float2(1, 0)),
                               Sample(position: vector_float2(-1, -1), uv_coordinate: vector_float2(0, 1)),
                               Sample(position: vector_float2(1, 1), uv_coordinate: vector_float2(1, 0)),
                               Sample(position: vector_float2(1, -1), uv_coordinate: vector_float2(1, 1))]


internal struct Postprocessor {
    private let pipelineState: MTLRenderPipelineState
    private let texture: MTLTexture
    private let viewPort: MTLViewport
    internal init(pipelineState: MTLRenderPipelineState, texture: MTLTexture) {
        self.texture = texture
        self.pipelineState = pipelineState
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(texture.width), height: Double(texture.height),
                                    znear: 0, zfar: 1)
    }
    internal func draw(encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentTexture(texture, index: 0)
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        coordinates.withUnsafeBytes { pointer in
            encoder.setVertexBytes(pointer.baseAddress!, length: pointer.count, index: 0)
        }
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
    }
    internal static func buildPostprocessingRenderPipelineState(device: MTLDevice,
                                                               library: MTLLibrary,
                                                               pixelFormat: MTLPixelFormat) -> MTLRenderPipelineState {
        let vertexShader = library.makeFunction(name: "vertexPostprocess")
        let fragmentShader = library.makeFunction(name: "fragmentPostprocess")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexShader
        pipelineDescriptor.fragmentFunction = fragmentShader
        pipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        pipelineDescriptor.vertexBuffers[0].mutability = .immutable
        return try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
}

//
//  ForwardRenderer.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import MetalKit
import ShaderTypes

fileprivate struct Uniforms {
    let projectionMatrix: matrix_float4x4
    let orientation: matrix_float4x4
    let translation: simd_float3
    let scale: simd_float3
}

struct ForwardRenderer {
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    init(pipelineState: MTLRenderPipelineState, depthStencilState: MTLDepthStencilState, drawableSize: CGSize) {
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(drawableSize.width), height: Double(drawableSize.height),
                                    znear: 0, zfar: 1)
    }
    func draw(encoder: MTLRenderCommandEncoder, scene: inout Scene, lightsBuffer: inout MTLBuffer) {
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setCullMode(.back)
        encoder.setFrontFacing(.counterClockwise)
        let uniforms = Uniforms(projectionMatrix: scene.camera.projectionMatrix,
                                orientation: simd_matrix4x4(scene.camera.coordinateSpace.orientation),
                                translation: scene.camera.coordinateSpace.translation,
                                scale: scene.camera.coordinateSpace.scale)
        withUnsafePointer(to: uniforms) { ptr in
            encoder.setVertexBytes(ptr, length: MemoryLayout<Uniforms>.size, index: 1)
        }
        for piece in scene.models {
            encoder.setVertexBuffer(piece.geometry.vertexBuffer.buffer,
                                    offset: piece.geometry.vertexBuffer.offset, index: 0)
            encoder.setFragmentTexture(piece.material.albedo, index: 0)
            encoder.setFragmentTexture(piece.material.roughness, index: 1)
            encoder.setFragmentTexture(piece.material.emission, index: 2)
            encoder.setFragmentTexture(piece.material.normals, index: 3)
            encoder.setFragmentTexture(piece.material.metallic, index: 4)
            for description in piece.geometry.drawDescription {
                encoder.drawIndexedPrimitives(type: description.primitiveType,
                                              indexCount: description.indexCount,
                                              indexType: description.indexType,
                                              indexBuffer: description.indexBuffer.buffer,
                                              indexBufferOffset: description.indexBuffer.offset)
            }
        }
    }
    static func buildForwardRendererPipelineState(device: MTLDevice,
                                                           library: MTLLibrary,
                                                           pixelFormat: MTLPixelFormat) -> MTLRenderPipelineState {
        let vertexShader = library.makeFunction(name: "vertexFunction")
        let fragmentShader = library.makeFunction(name: "fragmentFunction")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexShader
        pipelineDescriptor.fragmentFunction = fragmentShader
        pipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(MDLVertexDescriptor.porcelainMeshVertexDescriptor)
        return try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    static func buildDepthStencilPipelineState(device: MTLDevice) -> MTLDepthStencilState {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .lessEqual
        depthStencilDescriptor.isDepthWriteEnabled = true
        return device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
    }
}

//
//  ForwardRenderer.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 07/11/2020.
//

import MetalKit

fileprivate struct Uniforms {
    let projectionMatrix: matrix_float4x4
    let rotation: matrix_float4x4
    let translation: simd_float3
    let scale: simd_float3
}

internal struct ForwardRenderer {
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let viewPort: MTLViewport
    internal init(pipelineState: MTLRenderPipelineState, depthStencilState: MTLDepthStencilState, drawableSize: CGSize) {
        self.pipelineState = pipelineState
        self.depthStencilState = depthStencilState
        self.viewPort = MTLViewport(originX: 0, originY: 0,
                                    width: Double(drawableSize.width), height: Double(drawableSize.height),
                                    znear: 0, zfar: 1)
    }
    internal func draw(encoder: MTLRenderCommandEncoder, scene: inout Scene) {
        encoder.setViewport(viewPort)
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthStencilState)
        encoder.setCullMode(.back)
        encoder.setFrontFacing(.counterClockwise)
        let uniforms = Uniforms(projectionMatrix: scene.camera.projectionMatrix,
                                rotation: simd_matrix4x4(scene.camera.coordinateSpace.rotation),
                                translation: scene.camera.coordinateSpace.translation,
                                scale: scene.camera.coordinateSpace.scale)
        withUnsafePointer(to: uniforms) { ptr in
            encoder.setVertexBytes(ptr, length: MemoryLayout<Uniforms>.size, index: 1)
        }  
        for mesh in scene.meshes {
            encoder.setVertexBuffer(mesh.vertexBuffers[0].buffer, offset: mesh.vertexBuffers[0].offset, index: 0)
            for submesh in mesh.submeshes {
                encoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                              indexCount: submesh.indexCount,
                                              indexType: submesh.indexType,
                                              indexBuffer: submesh.indexBuffer.buffer,
                                              indexBufferOffset: submesh.indexBuffer.offset)
            }
        }
    }
    internal static func buildForwardRendererPipelineState(device: MTLDevice,
                                                           library: MTLLibrary,
                                                           pixelFormat: MTLPixelFormat) -> MTLRenderPipelineState {
        let vertexShader = library.makeFunction(name: "vertexFunction")
        let fragmentShader = library.makeFunction(name: "fragmentFunction")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexShader
        pipelineDescriptor.fragmentFunction = fragmentShader
        pipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        return try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    internal static func buildDepthStencilPipelineState(device: MTLDevice) -> MTLDepthStencilState {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        return device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
    }
}

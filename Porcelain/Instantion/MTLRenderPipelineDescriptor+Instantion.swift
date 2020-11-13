//
//  MTLRenderPipelineDescriptor.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 13/11/2020.
//

import Metal
import ModelIO
import MetalKit

extension MTLRenderPipelineDescriptor {
    static func forwardRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexFunction")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentFunction")
        descriptor.colorAttachments[0].pixelFormat = .rgba32Float
        descriptor.depthAttachmentPixelFormat = .depth32Float
        descriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(MDLVertexDescriptor.porcelainMeshVertexDescriptor)
        return descriptor
    }
    static func postProcessor(library: MTLLibrary, format: MTLPixelFormat) -> MTLRenderPipelineDescriptor {
        let vertexShader = library.makeFunction(name: "vertexPostprocess")
        let fragmentShader = library.makeFunction(name: "fragmentPostprocess")
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexShader
        descriptor.fragmentFunction = fragmentShader
        descriptor.colorAttachments[0].pixelFormat = format
        descriptor.vertexBuffers[0].mutability = .immutable
        return descriptor
    }
}

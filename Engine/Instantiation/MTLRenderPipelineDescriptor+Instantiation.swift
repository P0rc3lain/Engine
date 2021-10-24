//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import ModelIO
import MetalKit

extension MTLRenderPipelineDescriptor {
    static func postProcessor(library: MTLLibrary, format: MTLPixelFormat) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexPostprocess")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentPostprocess")
        descriptor.colorAttachments[0].pixelFormat = format
        descriptor.vertexBuffers[0].mutability = .immutable
        descriptor.vertexDescriptor = .porcelain
        return descriptor
    }
    static func environmentRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "environmentVertexShader")
        descriptor.fragmentFunction = library.makeFunction(name: "environmentFragmentShader")
        descriptor.colorAttachments[0].pixelFormat = .environmentRendererColor
        descriptor.depthAttachmentPixelFormat = .environmentRendererDepthStencil
        descriptor.stencilAttachmentPixelFormat = .environmentRendererDepthStencil
        descriptor.vertexDescriptor = MTLVertexDescriptor.environmentRenderer
        return descriptor
    }
    static func gBufferRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "gBufferVertex")
        descriptor.fragmentFunction = library.makeFunction(name: "gBufferFragment")
        descriptor.colorAttachments[0].pixelFormat = .gBufferAR
        descriptor.colorAttachments[1].pixelFormat = .gBufferNM
        descriptor.colorAttachments[2].pixelFormat = .gBufferPR
        descriptor.depthAttachmentPixelFormat = .gBufferDepthStencil
        descriptor.stencilAttachmentPixelFormat = .gBufferDepthStencil
        descriptor.vertexDescriptor = .porcelain
        return descriptor
    }
    static func gBufferAnimatedRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.gBufferRenderer(library: library)
        descriptor.vertexFunction = library.makeFunction(name: "gBufferAnimatedVertex")
        return descriptor
    }
    static func lightRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexDeferredLight")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentDeferredLight")
        descriptor.colorAttachments[0].pixelFormat = .lightenSceneColor
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .lightenSceneDepthStencil
        descriptor.stencilAttachmentPixelFormat = .lightenSceneDepthStencil
        descriptor.vertexDescriptor = .porcelain
        return descriptor
    }
}

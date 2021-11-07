//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalKit
import ModelIO

extension MTLRenderPipelineDescriptor {
    static func postProcessor(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexPostprocess")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentPostprocess")
        descriptor.colorAttachments[0].pixelFormat = .postprocessorRendererColor
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
    static func omniRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
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
    static func ambientRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexAmbientLight")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentAmbientLight")
        descriptor.colorAttachments[0].pixelFormat = .ambientColor
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .ambientDepthStencil
        descriptor.stencilAttachmentPixelFormat = .ambientDepthStencil
        descriptor.vertexDescriptor = .porcelain
        return descriptor
    }
    static func directionalRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexDirectionalLight")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentDirectionalLight")
        descriptor.colorAttachments[0].pixelFormat = .directionalColor
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .ambientDepthStencil
        descriptor.stencilAttachmentPixelFormat = .ambientDepthStencil
        descriptor.vertexDescriptor = .porcelain
        return descriptor
    }
    static func spotRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexSpotLight")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentSpotLight")
        descriptor.colorAttachments[0].pixelFormat = .spotColor
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .spotDepthStencil
        descriptor.stencilAttachmentPixelFormat = .spotDepthStencil
        descriptor.vertexDescriptor = .porcelain
        return descriptor
    }
    static func ssaoRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexSsao")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentSsao")
        descriptor.colorAttachments[0].pixelFormat = .ssaoColor
        descriptor.vertexDescriptor = .porcelain
        return descriptor
    }
    static func bloomSplitRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexBloomSplit")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentBloomSplit")
        descriptor.colorAttachments[0].pixelFormat = .bloomSplitColor
        descriptor.vertexDescriptor = .porcelain
        return descriptor
    }
    static func bloomMergeRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexBloomMerge")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentBloomMerge")
        descriptor.colorAttachments[0].pixelFormat = .bloomSplitColor
        descriptor.vertexDescriptor = .porcelain
        return descriptor
    }
}

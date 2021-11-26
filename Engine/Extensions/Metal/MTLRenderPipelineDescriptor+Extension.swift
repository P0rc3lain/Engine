//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalKit
import ModelIO

extension MTLRenderPipelineDescriptor {
    static func vignette(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Vignette"
        descriptor.vertexFunction = library.makeFunction(name: "vertexVignette")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentVignette")
        descriptor.colorAttachments[0].pixelFormat = .vignetteColor
        descriptor.vertexBuffers[0].mutability = .immutable
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func environmentRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Environment"
        descriptor.vertexFunction = library.makeFunction(name: "environmentVertexShader")
        descriptor.fragmentFunction = library.makeFunction(name: "environmentFragmentShader")
        descriptor.colorAttachments[0].pixelFormat = .environmentRendererColor
        descriptor.depthAttachmentPixelFormat = .environmentRendererDepthStencil
        descriptor.stencilAttachmentPixelFormat = .environmentRendererDepthStencil
        descriptor.vertexDescriptor = .vertexP
        return descriptor
    }
    static func gBufferRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "GBuffer"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexGBuffer",
                                                              constantValues: .bool(false, index: 0))
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentGBuffer")
        descriptor.colorAttachments[0].pixelFormat = .gBufferAR
        descriptor.colorAttachments[1].pixelFormat = .gBufferNM
        descriptor.colorAttachments[2].pixelFormat = .gBufferPR
        descriptor.depthAttachmentPixelFormat = .gBufferDepthStencil
        descriptor.stencilAttachmentPixelFormat = .gBufferDepthStencil
        descriptor.vertexDescriptor = .vertex
        return descriptor
    }
    static func gBufferAnimatedRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.gBufferRenderer(library: library)
        descriptor.label = "GBuffer Animated"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexGBuffer",
                                                              constantValues: .bool(true, index: 0))
        return descriptor
    }
    static func spotLightShadowRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Spot Shadows"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexSpotLightShadow",
                                                              constantValues: .bool(false, index: 0))
        descriptor.depthAttachmentPixelFormat = .spotShadowDepthStencil
        descriptor.vertexDescriptor = .vertex
        descriptor.sampleCount = 1
        descriptor.inputPrimitiveTopology = .triangle
        return descriptor
    }
    static func spotLightShadowAnimatedRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.spotLightShadowRenderer(library: library)
        descriptor.label = "Spot Shadows Animated"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexSpotLightShadow",
                                                              constantValues: .bool(true, index: 0))
        return descriptor
    }
    static func omniRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Omni Lighting"
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
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func ambientRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Ambient Lighting"
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
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func directionalRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Directional Lighting"
        descriptor.vertexFunction = library.makeFunction(name: "vertexDirectionalLight")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentDirectionalLight")
        descriptor.colorAttachments[0].pixelFormat = .directionalColor
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .directionalDepthStencil
        descriptor.stencilAttachmentPixelFormat = .directionalDepthStencil
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func spotRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Spot Lighting"
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
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func ssaoRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "SSAO"
        descriptor.vertexFunction = library.makeFunction(name: "vertexSSAO")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentSSAO")
        descriptor.colorAttachments[0].pixelFormat = .ssaoColor
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func bloomSplitRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Bloom Split"
        descriptor.vertexFunction = library.makeFunction(name: "vertexBloomSplit")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentBloomSplit")
        descriptor.colorAttachments[0].pixelFormat = .bloomSplitColor
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func bloomMergeRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Bloom Merge"
        descriptor.vertexFunction = library.makeFunction(name: "vertexBloomMerge")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentBloomMerge")
        descriptor.colorAttachments[0].pixelFormat = .bloomSplitColor
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func omniLightShadowRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Omni Shadows"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexOmniLightShadow",
                                                              constantValues: .bool(false, index: 0))
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentOmniLightShadow")
        descriptor.depthAttachmentPixelFormat = .omniShadowDepthStencil
        descriptor.vertexDescriptor = .vertex
        descriptor.sampleCount = 1
        descriptor.inputPrimitiveTopology = .triangle
        return descriptor
    }
    static func omniLightShadowAnimatedRenderer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.omniLightShadowRenderer(library: library)
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexOmniLightShadow",
                                                              constantValues: .bool(true, index: 0))
        descriptor.label = "Omni Shadows Animated"
        return descriptor
    }
}

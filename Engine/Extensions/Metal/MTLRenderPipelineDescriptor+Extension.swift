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
        descriptor.colorAttachments[0].pixelFormat = .vignetteC
        descriptor.vertexBuffers[0].mutability = .immutable
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func grain(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Grain"
        descriptor.vertexFunction = library.makeFunction(name: "vertexGrain")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentGrain")
        descriptor.colorAttachments[0].pixelFormat = .grainC
        descriptor.vertexBuffers[0].mutability = .immutable
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func environment(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Environment"
        descriptor.vertexFunction = library.makeFunction(name: "environmentVertexShader")
        descriptor.fragmentFunction = library.makeFunction(name: "environmentFragmentShader")
        descriptor.colorAttachments[0].pixelFormat = .environmentC
        descriptor.depthAttachmentPixelFormat = .environmentDS
        descriptor.stencilAttachmentPixelFormat = .environmentDS
        descriptor.vertexDescriptor = .vertexP
        return descriptor
    }
    static func fog(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Fog"
        descriptor.vertexFunction = library.makeFunction(name: "fogVertexShader")
        descriptor.fragmentFunction = library.makeFunction(name: "fogFragmentShader")
        descriptor.colorAttachments[0].pixelFormat = .fogC
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceRGBBlendFactor = .oneMinusSourceAlpha
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .sourceAlpha
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.depthAttachmentPixelFormat = .fogDS
        descriptor.stencilAttachmentPixelFormat = .fogDS
        descriptor.vertexDescriptor = .vertexP
        return descriptor
    }
    static func gBuffer(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "GBuffer"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexGBuffer",
                                                              constantValues: .bool(false, index: 0))
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentGBuffer")
        descriptor.colorAttachments[0].pixelFormat = .gBufferARC
        descriptor.colorAttachments[1].pixelFormat = .gBufferNMC
        descriptor.colorAttachments[2].pixelFormat = .gBufferPRC
        descriptor.depthAttachmentPixelFormat = .gBufferDS
        descriptor.stencilAttachmentPixelFormat = .gBufferDS
        descriptor.vertexDescriptor = .vertex
        return descriptor
    }
    static func gBufferAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.gBuffer(library: library)
        descriptor.label = "GBuffer Animated"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexGBuffer",
                                                              constantValues: .bool(true, index: 0))
        return descriptor
    }
    static func spotShadow(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Spot Shadows"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexSpotLightShadow",
                                                              constantValues: .bool(false, index: 0))
        descriptor.depthAttachmentPixelFormat = .spotShadowDS
        descriptor.vertexDescriptor = .vertex
        descriptor.sampleCount = 1
        descriptor.inputPrimitiveTopology = .triangle
        return descriptor
    }
    static func spotShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.spotShadow(library: library)
        descriptor.label = "Spot Shadows Animated"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexSpotLightShadow",
                                                              constantValues: .bool(true, index: 0))
        return descriptor
    }
    static func directionalShadow(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Directional Shadows"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexDirectionalLightShadow",
                                                              constantValues: .bool(false, index: 0))
        descriptor.depthAttachmentPixelFormat = .directionalShadowDS
        descriptor.vertexDescriptor = .vertex
        descriptor.sampleCount = 1
        descriptor.inputPrimitiveTopology = .triangle
        return descriptor
    }
    static func directionalShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.spotShadow(library: library)
        descriptor.label = "Directional Shadows Animated"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexDirectionalLightShadow",
                                                              constantValues: .bool(true, index: 0))
        return descriptor
    }
    static func omni(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Omni Lighting"
        descriptor.vertexFunction = library.makeFunction(name: "vertexDeferredLight")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentDeferredLight")
        descriptor.colorAttachments[0].pixelFormat = .lightenSceneC
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .lightenSceneDS
        descriptor.stencilAttachmentPixelFormat = .lightenSceneDS
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func ambient(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Ambient Lighting"
        descriptor.vertexFunction = library.makeFunction(name: "vertexAmbientLight")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentAmbientLight")
        descriptor.colorAttachments[0].pixelFormat = .ambientC
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .ambientDS
        descriptor.stencilAttachmentPixelFormat = .ambientDS
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func directional(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Directional Lighting"
        descriptor.vertexFunction = library.makeFunction(name: "vertexDirectionalLight")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentDirectionalLight")
        descriptor.colorAttachments[0].pixelFormat = .directionalC
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .directionalDS
        descriptor.stencilAttachmentPixelFormat = .directionalDS
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func spot(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Spot Lighting"
        descriptor.vertexFunction = library.makeFunction(name: "vertexSpotLight")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentSpotLight")
        descriptor.colorAttachments[0].pixelFormat = .spotC
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .spotDS
        descriptor.stencilAttachmentPixelFormat = .spotDS
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func ssao(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "SSAO"
        descriptor.vertexFunction = library.makeFunction(name: "vertexSSAO")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentSSAO")
        descriptor.colorAttachments[0].pixelFormat = .ssaoC
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func bloomSplit(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Bloom Split"
        descriptor.vertexFunction = library.makeFunction(name: "vertexBloomSplit")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentBloomSplit")
        descriptor.colorAttachments[0].pixelFormat = .bloomSplitC
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func bloomMerge(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Bloom Merge"
        descriptor.vertexFunction = library.makeFunction(name: "vertexBloomMerge")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentBloomMerge")
        descriptor.colorAttachments[0].pixelFormat = .bloomSplitC
        descriptor.vertexDescriptor = .vertexPUV
        return descriptor
    }
    static func omniShadow(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Omni Shadows"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexOmniLightShadow",
                                                              constantValues: .bool(false, index: 0))
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentOmniLightShadow")
        descriptor.depthAttachmentPixelFormat = .omniShadowDS
        descriptor.vertexDescriptor = .vertex
        descriptor.sampleCount = 1
        descriptor.inputPrimitiveTopology = .triangle
        return descriptor
    }
    static func omniShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.omniShadow(library: library)
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexOmniLightShadow",
                                                              constantValues: .bool(true, index: 0))
        descriptor.label = "Omni Shadows Animated"
        return descriptor
    }
}

//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import PNShared
import simd

extension MTLRenderPipelineDescriptor {
    static func environment(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Environment"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "environmentVertexShader")
        descriptor.fragmentFunction = library.failOrMakeFunction(name: "environmentFragmentShader")
        descriptor.colorAttachments[0].pixelFormat = .environmentC
        descriptor.depthAttachmentPixelFormat = .environmentDS
        descriptor.stencilAttachmentPixelFormat = .environmentDS
        descriptor.vertexDescriptor = .vertexP
        return descriptor
    }
    static func fog(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Fog"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "fogVertexShader")
        descriptor.fragmentFunction = library.failOrMakeFunction(name: "fogFragmentShader")
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
        let values = MTLFunctionConstantValues
            .bool(false, index: kFunctionConstantGBufferHasSkeleton)
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "GBuffer"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexGBuffer", constantValues: values)
        descriptor.fragmentFunction = library.failOrMakeFunction(name: "fragmentGBuffer")
        descriptor.colorAttachments[kColorAttachmentGBufferAlbedoRoughness.int].pixelFormat = .gBufferARC
        descriptor.colorAttachments[kColorAttachmentGBufferNormalMetallic.int].pixelFormat = .gBufferNMC
        descriptor.colorAttachments[kColorAttachmentGBufferPositionReflectance.int].pixelFormat = .gBufferPRC
        descriptor.colorAttachments[kColorAttachmentGBufferVelocity.int].pixelFormat = .gBufferVelocity
        descriptor.depthAttachmentPixelFormat = .gBufferDS
        descriptor.stencilAttachmentPixelFormat = .gBufferDS
        descriptor.vertexDescriptor = .vertex
        return descriptor
    }
    static func gBufferAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let values = MTLFunctionConstantValues
            .bool(true, index: kFunctionConstantGBufferHasSkeleton)
        let descriptor = MTLRenderPipelineDescriptor.gBuffer(library: library)
        descriptor.label = "GBuffer Animated"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexGBuffer",
                                                               constantValues: values)
        return descriptor
    }
    static func translucent(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let values = MTLFunctionConstantValues
            .bool(false, index: kFunctionConstantTranslucentHasSkeleton)
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Translucent"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexTranslucent",
                                                               constantValues: values)
        descriptor.fragmentFunction = library.failOrMakeFunction(name: "fragmentTranslucent")
        descriptor.colorAttachments[0].pixelFormat = .translucentC
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.depthAttachmentPixelFormat = .translucentDS
        descriptor.stencilAttachmentPixelFormat = .translucentDS
        descriptor.vertexDescriptor = .vertex
        return descriptor
    }
    static func boundingBox(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "BoundingBox"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexBoundingBox")
        descriptor.fragmentFunction = library.failOrMakeFunction(name: "fragmentBoundingBox")
        descriptor.colorAttachments[0].pixelFormat = .boundingBoxC
        descriptor.depthAttachmentPixelFormat = .boundingBoxDS
        descriptor.stencilAttachmentPixelFormat = .boundingBoxDS
        descriptor.vertexDescriptor = .vertexP
        return descriptor
    }
    static func particle(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Particle"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexParticle")
        descriptor.fragmentFunction = library.failOrMakeFunction(name: "fragmentParticle")
        descriptor.colorAttachments[0].pixelFormat = .particleC
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.depthAttachmentPixelFormat = .particleDS
        descriptor.stencilAttachmentPixelFormat = .particleDS
        descriptor.vertexDescriptor = .particle
        return descriptor
    }
    static func translucentAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let values = MTLFunctionConstantValues
            .bool(true, index: kFunctionConstantTranslucentHasSkeleton)
        let descriptor = MTLRenderPipelineDescriptor.translucent(library: library)
        descriptor.label = "Translucent Animated"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexTranslucent",
                                                               constantValues: values)
        return descriptor
    }
    static func spotShadow(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let values = MTLFunctionConstantValues
            .bool(false, index: kFunctionConstantSpotShadowHasSkeleton)
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Spot Shadows"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexSpotLightShadow",
                                                               constantValues: values)
        descriptor.depthAttachmentPixelFormat = .spotShadowDS
        descriptor.vertexDescriptor = .vertex
        descriptor.rasterSampleCount = 1
        descriptor.inputPrimitiveTopology = .triangle
        return descriptor
    }
    static func spotShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let values = MTLFunctionConstantValues
            .bool(true, index: kFunctionConstantSpotShadowHasSkeleton)
        let descriptor = MTLRenderPipelineDescriptor.spotShadow(library: library)
        descriptor.label = "Spot Shadows Animated"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexSpotLightShadow",
                                                               constantValues: values)
        return descriptor
    }
    static func directionalShadow(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let values = MTLFunctionConstantValues
            .bool(false, index: kFunctionConstantDirectionalShadowHasSkeleton)
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Directional Shadows"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexDirectionalLightShadow",
                                                               constantValues: values)
        descriptor.depthAttachmentPixelFormat = .directionalShadowDS
        descriptor.vertexDescriptor = .vertex
        descriptor.rasterSampleCount = 1
        descriptor.inputPrimitiveTopology = .triangle
        return descriptor
    }
    static func directionalShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let values = MTLFunctionConstantValues
            .bool(true, index: kFunctionConstantDirectionalShadowHasSkeleton)
        let descriptor = MTLRenderPipelineDescriptor.directionalShadow(library: library)
        descriptor.label = "Directional Shadows Animated"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexDirectionalLightShadow",
                                                               constantValues: values)
        return descriptor
    }
    static func omni(library: MTLLibrary,
                     settings: PNDefaults.PNOmniLighting) -> MTLRenderPipelineDescriptor {
        let values = MTLFunctionConstantValues
            .int3(settings.pcfRange, index: kFunctionConstantIndexOmniPcfRange)
            .float2(settings.shadowBias, index: kFunctionConstantIndexOmniShadowBias)
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Omni Lighting"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexOmniLight")
        descriptor.fragmentFunction = library.failOrMakeFunction(name: "fragmentOmniLight",
                                                                 constantValues: values)
        descriptor.colorAttachments[0].pixelFormat = .lightenSceneC
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .lightenSceneDS
        descriptor.stencilAttachmentPixelFormat = .lightenSceneDS
        descriptor.vertexDescriptor = .vertex
        return descriptor
    }
    static func ambient(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Ambient Lighting"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexAmbientLight")
        descriptor.fragmentFunction = library.failOrMakeFunction(name: "fragmentAmbientLight")
        descriptor.colorAttachments[0].pixelFormat = .ambientC
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .ambientDS
        descriptor.stencilAttachmentPixelFormat = .ambientDS
        descriptor.vertexDescriptor = .vertex
        return descriptor
    }
    static func directional(library: MTLLibrary,
                            settings: PNDefaults.PNDirectionalLighting) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        let values = MTLFunctionConstantValues
            .int2(settings.pcfRange, index: kFunctionConstantIndexDirectionalPcfRange)
            .float2(settings.shadowBias, index: kFunctionConstantIndexDirectionalShadowBias)
        descriptor.label = "Directional Lighting"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexDirectionalLight")
        descriptor.fragmentFunction = library.failOrMakeFunction(name: "fragmentDirectionalLight",
                                                                 constantValues: values)
        descriptor.colorAttachments[0].pixelFormat = .directionalC
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .directionalDS
        descriptor.stencilAttachmentPixelFormat = .directionalDS
        descriptor.vertexDescriptor = .vertex
        return descriptor
    }
    static func spot(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Spot Lighting"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexSpotLight")
        descriptor.fragmentFunction = library.failOrMakeFunction(name: "fragmentSpotLight")
        descriptor.colorAttachments[0].pixelFormat = .spotC
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .one
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].alphaBlendOperation = .max
        descriptor.depthAttachmentPixelFormat = .spotDS
        descriptor.stencilAttachmentPixelFormat = .spotDS
        descriptor.vertexDescriptor = .vertex
        return descriptor
    }
    static func omniShadow(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let values = MTLFunctionConstantValues
            .bool(false, index: kFunctionConstantOmniShadowHasSkeleton)
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Omni Shadows"
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexOmniLightShadow",
                                                               constantValues: values)
        descriptor.depthAttachmentPixelFormat = .omniShadowDS
        descriptor.vertexDescriptor = .vertex
        descriptor.rasterSampleCount = 1
        descriptor.inputPrimitiveTopology = .triangle
        return descriptor
    }
    static func omniShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let values = MTLFunctionConstantValues
            .bool(true, index: kFunctionConstantOmniShadowHasSkeleton)
        let descriptor = MTLRenderPipelineDescriptor.omniShadow(library: library)
        descriptor.vertexFunction = library.failOrMakeFunction(name: "vertexOmniLightShadow",
                                                               constantValues: values)
        descriptor.label = "Omni Shadows Animated"
        return descriptor
    }
}

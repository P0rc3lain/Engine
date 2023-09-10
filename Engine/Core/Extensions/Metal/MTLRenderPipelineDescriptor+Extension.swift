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
                                                              constantValues: .bool(false, index: kFunctionConstantGBufferHasSkeleton))
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentGBuffer")
        descriptor.colorAttachments[kColorAttachmentGBufferAlbedoRoughness.int].pixelFormat = .gBufferARC
        descriptor.colorAttachments[kColorAttachmentGBufferNormalMetallic.int].pixelFormat = .gBufferNMC
        descriptor.colorAttachments[kColorAttachmentGBufferPositionReflectance.int].pixelFormat = .gBufferPRC
        descriptor.depthAttachmentPixelFormat = .gBufferDS
        descriptor.stencilAttachmentPixelFormat = .gBufferDS
        descriptor.vertexDescriptor = .vertex
        return descriptor
    }
    static func gBufferAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.gBuffer(library: library)
        descriptor.label = "GBuffer Animated"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexGBuffer",
                                                              constantValues: .bool(true, index: kFunctionConstantGBufferHasSkeleton))
        return descriptor
    }
    static func translucent(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Translucent"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexTranslucent",
                                                              constantValues: .bool(false, index: kFunctionConstantTranslucentHasSkeleton))
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentTranslucent")
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
    static func particle(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Particle"
        descriptor.vertexFunction = library.makeFunction(name: "vertexParticle")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentParticle")
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
        let descriptor = MTLRenderPipelineDescriptor.translucent(library: library)
        descriptor.label = "Translucent Animated"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexTranslucent",
                                                              constantValues: .bool(true, index: kFunctionConstantTranslucentHasSkeleton))
        return descriptor
    }
    static func spotShadow(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Spot Shadows"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexSpotLightShadow",
                                                              constantValues: .bool(false, index: kFunctionConstantSpotShadowHasSkeleton))
        descriptor.depthAttachmentPixelFormat = .spotShadowDS
        descriptor.vertexDescriptor = .vertex
        descriptor.rasterSampleCount = 1
        descriptor.inputPrimitiveTopology = .triangle
        return descriptor
    }
    static func spotShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.spotShadow(library: library)
        descriptor.label = "Spot Shadows Animated"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexSpotLightShadow",
                                                              constantValues: .bool(true, index: kFunctionConstantSpotShadowHasSkeleton))
        return descriptor
    }
    static func directionalShadow(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Directional Shadows"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexDirectionalLightShadow",
                                                              constantValues: .bool(false, index: kFunctionConstantDirectionalShadowHasSkeleton))
        descriptor.depthAttachmentPixelFormat = .directionalShadowDS
        descriptor.vertexDescriptor = .vertex
        descriptor.rasterSampleCount = 1
        descriptor.inputPrimitiveTopology = .triangle
        return descriptor
    }
    static func directionalShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.directionalShadow(library: library)
        descriptor.label = "Directional Shadows Animated"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexDirectionalLightShadow",
                                                              constantValues: .bool(true, index: kFunctionConstantDirectionalShadowHasSkeleton))
        return descriptor
    }
    static func omni(library: MTLLibrary,
                     settings: PNDefaults.PNOmniLighting) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Omni Lighting"
        descriptor.vertexFunction = library.makeFunction(name: "vertexOmniLight")
        descriptor.fragmentFunction = try? library.makeFunction(name: "fragmentOmniLight",
                                                                constantValues: .int3(settings.pcfRange,
                                                                                            index: kFunctionConstantIndexOmniPcfRange)
                                                                                      .float2(settings.shadowBias,
                                                                                              index: kFunctionConstantIndexOmniShadowBias))
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
        descriptor.vertexFunction = library.makeFunction(name: "vertexDirectionalLight")
        descriptor.fragmentFunction = try? library.makeFunction(name: "fragmentDirectionalLight",
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
        descriptor.vertexDescriptor = .vertex
        return descriptor
    }
    static func omniShadow(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Omni Shadows"
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexOmniLightShadow",
                                                              constantValues: .bool(false, index: kFunctionConstantOmniShadowHasSkeleton))
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentOmniLightShadow")
        descriptor.depthAttachmentPixelFormat = .omniShadowDS
        descriptor.vertexDescriptor = .vertex
        descriptor.rasterSampleCount = 1
        descriptor.inputPrimitiveTopology = .triangle
        return descriptor
    }
    static func omniShadowAnimated(library: MTLLibrary) -> MTLRenderPipelineDescriptor {
        let descriptor = MTLRenderPipelineDescriptor.omniShadow(library: library)
        descriptor.vertexFunction = try? library.makeFunction(name: "vertexOmniLightShadow",
                                                              constantValues: .bool(true, index: kFunctionConstantOmniShadowHasSkeleton))
        descriptor.label = "Omni Shadows Animated"
        return descriptor
    }
}

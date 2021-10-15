//
//  RenderingCoordinator.swift
//  Engine
//
//  Created by Mateusz Stompór on 05/11/2020.
//

import Metal
import MetalKit
import ShaderTypes

public struct RenderingCoordinator {
    // MARK: - Private
    private let view: MTKView
    private let commandQueue: MTLCommandQueue
    private var offscreenRenderPassDescriptor: MTLRenderPassDescriptor
    private var gBufferRenderPassDescriptor: MTLRenderPassDescriptor
//    private var postProcessor: Postprocessor
    private var gBufferRenderer: GBufferRenderer
//    private var environmentRenderer: EnvironmentRenderer
//    private var lightRenderer: LightPassRenderer
    private var bufferStore: BufferStore
    let canvasSize: CGSize
    let renderingSize: CGSize
    // MARK: - Initialization
    init(view metalView: MTKView, canvasSize: CGSize, renderingSize: CGSize) {
        self.view = metalView
        self.canvasSize = canvasSize
        self.renderingSize = renderingSize
        commandQueue = view.device!.makeCommandQueue()!
        bufferStore = BufferStore(device: view.device!)
        gBufferRenderPassDescriptor = MTLRenderPassDescriptor.gBuffer(device: view.device!, size: renderingSize)
        offscreenRenderPassDescriptor = MTLRenderPassDescriptor.lightenScene(device: view.device!,
                                                                             depthStencil: gBufferRenderPassDescriptor.stencilAttachment.texture!,
                                                                             size: renderingSize)
//        postProcessor = Postprocessor.make(device: view.device!,
//                                           inputTexture: offscreenRenderPassDescriptor.colorAttachments[0].texture!,
//                                           outputFormat: view.colorPixelFormat,
//                                           canvasSize: canvasSize)
//        environmentRenderer = EnvironmentRenderer.make(device: view.device!, drawableSize: view.drawableSize)
        gBufferRenderer = GBufferRenderer.make(device: view.device!, drawableSize: renderingSize)
//        lightRenderer = LightPassRenderer.make(device: view.device!, gBufferRenderPassDescriptor: gBufferRenderPassDescriptor, drawableSize: renderingSize)
    }
    public mutating func draw(scene: inout GPUSceneDescription) {
//        bufferStore.omniLights.upload(data: &scene.omniLights)
        var camera = scene.objects.objects.filter { $0.data.type == .camera }.first!
        bufferStore.upload(camera: &scene.cameras[camera.data.referenceIdx], transform: &camera.data.transform)
        bufferStore.upload(models: &scene.objects)
//
        let commandBuffer = commandQueue.makeCommandBuffer()!
        commandBuffer.pushDebugGroup("G-Buffer Renderer Pass")
        var gBufferEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: gBufferRenderPassDescriptor)!
        
        gBufferRenderer.draw(encoder: &gBufferEncoder, scene: &scene, dataStore: &bufferStore)
        gBufferEncoder.endEncoding()
        commandBuffer.popDebugGroup()
//
//        var lightEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor)!
//
//        commandBuffer.pushDebugGroup("Light Pass")
//        lightRenderer.draw(encoder: &lightEncoder, bufferStore: &bufferStore, lightsCount: scene.omniLights.count)
//        commandBuffer.popDebugGroup()
//
//        commandBuffer.pushDebugGroup("Environment Map")
//        environmentRenderer.draw(encoder: lightEncoder, scene: &scene)
//        commandBuffer.popDebugGroup()
//
//        lightEncoder.endEncoding()
//
//
//        commandBuffer.pushDebugGroup("Post Processing Pass")
//        let texturePass = commandBuffer.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)!
//        postProcessor.draw(encoder: texturePass)
//        texturePass.endEncoding()
//        commandBuffer.popDebugGroup()
//    
//
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
}

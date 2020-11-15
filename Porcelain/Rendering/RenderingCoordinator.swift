//
//  RenderingCoordinator.swift
//  Porcelain
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
    private var postProcessor: Postprocessor
    private var gBufferRenderer: GBufferRenderer
    private var environmentRenderer: EnvironmentRenderer
    private var lightRenderer: LightPassRenderer
    private var lights: DynamicBuffer<OmniLight>
    private var drawUniforms: StaticBuffer<FRDrawUniforms>
    let canvasSize: CGSize
    let renderingSize: CGSize
    // MARK: - Initialization
    init(view metalView: MTKView, canvasSize: CGSize, renderingSize: CGSize) {
        self.view = metalView
        self.canvasSize = canvasSize
        self.renderingSize = renderingSize
        commandQueue = view.device!.makeCommandQueue()!
        lights = DynamicBuffer<OmniLight>(device: view.device!, initialCapacity: 2)!
        drawUniforms = StaticBuffer<FRDrawUniforms>(device: view.device!, capacity: 1)!
        gBufferRenderPassDescriptor = MTLRenderPassDescriptor.gBuffer(device: view.device!, size: renderingSize)
        offscreenRenderPassDescriptor = MTLRenderPassDescriptor.lightenScene(device: view.device!,
                                                                             depthStencil: gBufferRenderPassDescriptor.stencilAttachment.texture!,
                                                                             size: renderingSize)
        postProcessor = Postprocessor.make(device: view.device!,
                                           inputTexture: offscreenRenderPassDescriptor.colorAttachments[0].texture!,
                                           outputFormat: view.colorPixelFormat,
                                           canvasSize: canvasSize)
        environmentRenderer = EnvironmentRenderer.make(device: view.device!, drawableSize: view.drawableSize)
        gBufferRenderer = GBufferRenderer.make(device: view.device!, drawableSize: renderingSize)
        lightRenderer = LightPassRenderer.make(device: view.device!, gBufferRenderPassDescriptor: gBufferRenderPassDescriptor, drawableSize: renderingSize)
    }
    public mutating func draw(scene: inout Scene) {
        lights.upload(data: &scene.omniLights)
        var uniforms = [FRDrawUniforms(projectionMatrix: scene.camera.projectionMatrix,
                                       viewMatrix: scene.camera.coordinateSpace.transformationRTS,
                                       viewMatrixInverse: scene.camera.coordinateSpace.transformationRTS.inverse,
                                       omniLightsCount: Int32(scene.omniLights.count))]
        drawUniforms.upload(data: &uniforms)
        let commandBuffer = commandQueue.makeCommandBuffer()!
        commandBuffer.pushDebugGroup("G-Buffer Renderer Pass")
        var gBufferEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: gBufferRenderPassDescriptor)!
        
        gBufferRenderer.draw(encoder: &gBufferEncoder, scene: &scene, lightsBuffer: &lights.buffer, drawUniformsBuffer: &drawUniforms.buffer)
        gBufferEncoder.endEncoding()
        commandBuffer.popDebugGroup()
        
        var lightEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor)!
        
        commandBuffer.pushDebugGroup("Light Pass")
        lightRenderer.draw(encoder: &lightEncoder, lightsBuffer: &lights.buffer, drawUniformsBuffer: &drawUniforms.buffer, lightsCount: scene.omniLights.count)
        commandBuffer.popDebugGroup()
        
        commandBuffer.pushDebugGroup("Environment Map")
        environmentRenderer.draw(encoder: lightEncoder, camera: &scene.camera, environmentMap: &scene.environmentMap)
        commandBuffer.popDebugGroup()
        
        lightEncoder.endEncoding()
        
        
        commandBuffer.pushDebugGroup("Post Processing Pass")
        let texturePass = commandBuffer.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)!
        postProcessor.draw(encoder: texturePass)
        texturePass.endEncoding()
        commandBuffer.popDebugGroup()

        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
}

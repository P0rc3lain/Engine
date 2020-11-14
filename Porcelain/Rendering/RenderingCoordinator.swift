//
//  RenderingCoordinator.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 05/11/2020.
//

import Metal
import MetalKit

public struct RenderingCoordinator {
    // MARK: - Private
    private let view: MTKView
    private let commandQueue: MTLCommandQueue
    private var offscreenRenderPassDescriptor: MTLRenderPassDescriptor
    private var forwardRenderer: ForwardRenderer
    private var postProcessor: Postprocessor
    private var environmentRenderer: EnvironmentRenderer
    private var lights: SharedBuffer<OmniLight>
    private let drawableSize: CGSize
    // MARK: - Initialization
    init(view metalView: MTKView, drawableSize: CGSize) {
        self.view = metalView
        self.drawableSize = drawableSize
        commandQueue = view.device!.makeCommandQueue()!
        lights = SharedBuffer<OmniLight>(device: view.device!, initialCapacity: 2)!
        forwardRenderer = ForwardRenderer.make(device: view.device!, drawableSize: drawableSize)
        offscreenRenderPassDescriptor = MTLRenderPassDescriptor.lightenScene(device: view.device!, size: drawableSize)
        postProcessor = Postprocessor.make(device: view.device!, inputTexture: offscreenRenderPassDescriptor.colorAttachments[0].texture!, outputFormat: view.colorPixelFormat)
        environmentRenderer = EnvironmentRenderer.make(device: view.device!, drawableSize: drawableSize)
    }
    public mutating func draw(scene: inout Scene) {
        lights.upload(data: &scene.omniLights)
        let commandBuffer = commandQueue.makeCommandBuffer()!

        commandBuffer.pushDebugGroup("Environment mapping")
        var environmentEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor)!
        environmentRenderer.draw(encoder: environmentEncoder, camera: &scene.camera, environmentMap: &scene.environmentMap)
        commandBuffer.popDebugGroup()

        commandBuffer.pushDebugGroup("Forward Renderer Pass")
        forwardRenderer.draw(encoder: &environmentEncoder, scene: &scene, lightsBuffer: &lights.buffer)
        environmentEncoder.endEncoding()
        commandBuffer.popDebugGroup()

        commandBuffer.pushDebugGroup("Post Processing Pass")
        let texturePass = commandBuffer.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)!
        postProcessor.draw(encoder: texturePass)
        texturePass.endEncoding()
        commandBuffer.popDebugGroup()

        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }
}

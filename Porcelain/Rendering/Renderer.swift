//
//  Renderer.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 05/11/2020.
//

import Metal
import MetalKit

public struct Renderer {
    // MARK: - Private
    private let view: MTKView
    private let library: MTLLibrary
    private let commandQueue: MTLCommandQueue
    private var offscreenRenderPassDescriptor: MTLRenderPassDescriptor
    private var forwardRenderer: ForwardRenderer
    private var postProcessor: Postprocessor!
    private var environmentRenderer: EnvironmentRenderer
    private var lights: SharedBuffer<OmniLight>
    private let drawableSize: CGSize
    // MARK: - Initialization
    init(view metalView: MTKView, drawableSize: CGSize) {
        self.view = metalView
        self.drawableSize = drawableSize
        library = try! view.device!.makeDefaultLibrary(bundle: Bundle(for: Engine.self))
        commandQueue = view.device!.makeCommandQueue()!
        lights = SharedBuffer<OmniLight>(device: view.device!, initialCapacity: 2)!
        offscreenRenderPassDescriptor = MTLRenderPassDescriptor.lightenScene(device: view.device!, size: drawableSize)
        let pipelinePostprocessingState = view.device!.makeRenderPipelineStatePostprocessor(library: library, format: view.colorPixelFormat)
        postProcessor = Postprocessor(pipelineState: pipelinePostprocessingState, texture: offscreenRenderPassDescriptor.colorAttachments[0].texture!, plane: Geometry.screenSpacePlane(device: view.device!))
        let forwardRendererState = view.device!.makeRenderPipelineStateForwardRenderer(library: library)
        let depthStencilState = view.device!.makeDepthStencilStateForwardRenderer()
        forwardRenderer = ForwardRenderer(pipelineState: forwardRendererState, depthStencilState: depthStencilState, drawableSize: drawableSize)
        let environmentPipelineState = view.device!.makeRenderPipelineStateEnvironmentRenderer(library: library)
        environmentRenderer = EnvironmentRenderer(pipelineState: environmentPipelineState, drawableSize: drawableSize, cube: Geometry.cube(device: view.device!))
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

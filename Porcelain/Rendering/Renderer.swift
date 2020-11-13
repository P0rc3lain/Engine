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
    private let device: MTLDevice
    private let library: MTLLibrary
    private let commandQueue: MTLCommandQueue
    private var colorTexture: MTLTexture!
    private var depthTexture: MTLTexture!
    private var offscreenRenderPassDescriptor: MTLRenderPassDescriptor!
    private var forwardRenderer: ForwardRenderer!
    private var postProcessor: Postprocessor!
    private var environmentRenderer: EnvironmentRenderer!
    private var indices: MTLBuffer!
    private var lights: SharedBuffer<OmniLight>
    private var vertices: MTLBuffer!
    private let drawableSize: CGSize
    // MARK: - Initialization
    init(view metalView: MTKView, drawableSize: CGSize) {
        view = metalView
        self.drawableSize = drawableSize
        device = view.device!
        vertices = Cube.verticesBuffer(device: device)
        indices = Cube.indicesBuffer(device: device)
        library = try! device.makeDefaultLibrary(bundle: Bundle(for: Engine.self))
        commandQueue = self.device.makeCommandQueue()!
        lights = SharedBuffer<OmniLight>(device: device, initialCapacity: 2)!
        depthTexture = prepareDepthTexture()
        colorTexture = prepareColorTexture()
        offscreenRenderPassDescriptor = prepareOffscreenRenderPassDescriptor(colorTexture: colorTexture, depthTexture: depthTexture)
        let pipelinePostprocessingState = Postprocessor.buildPostprocessingRenderPipelineState(device: device,
                                                                                               library: library,
                                                                                               pixelFormat: view.colorPixelFormat)
        postProcessor = Postprocessor(pipelineState: pipelinePostprocessingState, texture: colorTexture)
        let forwardRendererState = ForwardRenderer.buildForwardRendererPipelineState(device: device, library: library, pixelFormat: view.colorPixelFormat)
        let depthStencilState = ForwardRenderer.buildDepthStencilPipelineState(device: device)
        forwardRenderer = ForwardRenderer(pipelineState: forwardRendererState,
                                          depthStencilState: depthStencilState,
                                          drawableSize: CGSize(width: colorTexture.width, height: colorTexture.height))
        
        let environmentPipelineState = EnvironmentRenderer.buildEnvironmentRenderPipelineState(device: device, library: library, pixelFormat: view.colorPixelFormat)
        environmentRenderer = EnvironmentRenderer(pipelineState: environmentPipelineState, drawableSize: drawableSize)
    }
    public mutating func draw(scene: inout Scene) {
        lights.upload(data: &scene.omniLights)
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        commandBuffer.pushDebugGroup("Environment mapping")
        let environmentEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor)!
        environmentRenderer.draw(encoder: environmentEncoder, camera: scene.camera, vertexBuffer: vertices, indicesBuffer: indices, environmentMap: scene.environmentMap)
        commandBuffer.popDebugGroup()
        
        commandBuffer.pushDebugGroup("Forward Renderer Pass")
        forwardRenderer.draw(encoder: environmentEncoder, scene: &scene, lightsBuffer: &lights.buffer)
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
    private func prepareDepthTexture() -> MTLTexture? {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(drawableSize.width)
        descriptor.height = Int(drawableSize.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = .depth32Float
        descriptor.usage = .renderTarget
        return device.makeTexture(descriptor: descriptor)
    }
    private func prepareColorTexture() -> MTLTexture? {
        let descriptor = MTLTextureDescriptor()
        descriptor.textureType = .type2D
        descriptor.width = Int(drawableSize.width)
        descriptor.height = Int(drawableSize.height)
        descriptor.storageMode = .private
        descriptor.pixelFormat = .bgra8Unorm
        descriptor.usage = [.shaderRead, .renderTarget]
        return device.makeTexture(descriptor: descriptor)
    }
    private func prepareOffscreenRenderPassDescriptor(colorTexture: MTLTexture, depthTexture: MTLTexture) -> MTLRenderPassDescriptor {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].texture = colorTexture
        descriptor.colorAttachments[0].clearColor = MTLClearColor.init()
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.depthAttachment.clearDepth = 1
        descriptor.depthAttachment.texture = depthTexture
        descriptor.depthAttachment.storeAction = .store
        return descriptor
    }
}
//
//  Renderer.swift
//  Porcelain
//
//  Created by Mateusz Stompór on 05/11/2020.
//

import Metal
import MetalKit

public class Renderer {
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
    private let drawableSize: CGSize
    // MARK: - Initialization
    public init(view metalView: MTKView, drawableSize: CGSize) {
        view = metalView
        self.drawableSize = drawableSize
        device = view.device!
        library = try! device.makeDefaultLibrary(bundle: Bundle(for: Renderer.self))
        commandQueue = self.device.makeCommandQueue()!
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
    }
    public func draw(scene: inout Scene) {
        let commandBuffer = commandQueue.makeCommandBuffer()!
        commandBuffer.pushDebugGroup("Forward Renderer Pass")
        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor)!
        forwardRenderer.draw(encoder: encoder, scene: &scene)
        encoder.endEncoding()
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

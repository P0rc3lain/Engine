//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import MetalKit
import MetalPerformanceShaders

public struct RenderingCoordinator {
    private let view: MTKView
    private let commandQueue: MTLCommandQueue
    private var offscreenRenderPassDescriptor: MTLRenderPassDescriptor
    private var gBufferRenderPassDescriptor: MTLRenderPassDescriptor
    private var ssaoRenderPassDescriptor: MTLRenderPassDescriptor
    private var postProcessor: Postprocessor
    private var gBufferRenderer: GBufferRenderer
    private var environmentRenderer: EnvironmentRenderer
    private var lightRenderer: LightPassRenderer
    private var ssaoRenderer: SsaoRenderer
    private var bufferStore: BufferStore
    private var bloomStage: BloomStage
    private let canvasSize: CGSize
    private let gaussTexture: MTLTexture
    private let gaussianBlur: MPSImageGaussianBlur
    let renderingSize: CGSize
    init?(view metalView: MTKView, canvasSize: CGSize, renderingSize: CGSize) {
        guard let device = metalView.device,
              let bufferStore = BufferStore(device: device),
              let commandQueue = device.makeCommandQueue() else {
            return nil
        }
        gBufferRenderPassDescriptor = .gBuffer(device: device, size: renderingSize)
        guard let sharedDepthStencilTexture = gBufferRenderPassDescriptor.stencilAttachment.texture else {
            return nil
        }
        offscreenRenderPassDescriptor = .lightenScene(device: device,
                                                      depthStencil: sharedDepthStencilTexture,
                                                      size: renderingSize)
        guard let bloomStage = BloomStage(input: offscreenRenderPassDescriptor.colorAttachments[0].texture!,
                                          device: device,
                                          renderingSize: renderingSize),
              let postProcessor = Postprocessor.make(device: device,
                                                     inputTexture: bloomStage.io.output.color[0],
                                                     outputFormat: metalView.colorPixelFormat,
                                                     canvasSize: canvasSize),
              let environmentRenderer = EnvironmentRenderer.make(device: device, drawableSize: metalView.drawableSize),
              let lightRenderer = LightPassRenderer.make(device: device,
                                                         gBufferRenderPassDescriptor: gBufferRenderPassDescriptor,
                                                         drawableSize: renderingSize),
              let gBufferRenderer = GBufferRenderer.make(device: device, drawableSize: renderingSize),
              let ssaoRenderer = SsaoRenderer.make(device: device,
                                                   gBufferRenderPassDescriptor: gBufferRenderPassDescriptor,
                                                   drawableSize: renderingSize),
              let gaussTexture = device.makeTexture(descriptor: .ssaoColor(size: renderingSize)) else {
            return nil
        }
        self.view = metalView
        self.gaussTexture = gaussTexture
        self.canvasSize = canvasSize
        self.renderingSize = renderingSize
        self.bufferStore = bufferStore
        self.bloomStage = bloomStage
        self.commandQueue = commandQueue
        self.postProcessor = postProcessor
        self.environmentRenderer = environmentRenderer
        self.gBufferRenderer = gBufferRenderer
        self.lightRenderer = lightRenderer
        self.ssaoRenderer = ssaoRenderer
        self.ssaoRenderPassDescriptor = .ssao(device: device, size: renderingSize)
        self.gaussianBlur = MPSImageGaussianBlur(device: device, sigma: 1)
    }
    public mutating func draw(scene: inout GPUSceneDescription) {
        guard scene.activeCameraIdx != .nil,
              var commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable else {
            return
        }
        updatePalettes(scene: &scene)
        bufferStore.omniLights.upload(data: &scene.lights)
        bufferStore.upload(camera: &scene.cameras[scene.entities[scene.activeCameraIdx].data.referenceIdx], index: scene.activeCameraIdx)
        bufferStore.upload(models: &scene.entities)
        guard var gBufferEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: gBufferRenderPassDescriptor) else {
            return
        }
        commandBuffer.pushDebugGroup("G-Buffer Renderer Pass")
        gBufferRenderer.draw(encoder: &gBufferEncoder, scene: &scene, dataStore: &bufferStore)
        gBufferEncoder.endEncoding()
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("SSAO Renderer Pass")
        guard var ssaoEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: ssaoRenderPassDescriptor) else {
            return
        }
        ssaoRenderer.draw(encoder: &ssaoEncoder, bufferStore: &bufferStore)
        ssaoEncoder.endEncoding()
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("MPS")
        guard let ssaoTexture = ssaoRenderPassDescriptor.colorAttachments[0].texture else {
            return
        }
        gaussianBlur.encode(commandBuffer: commandBuffer,
                            sourceTexture: ssaoTexture,
                            destinationTexture: gaussTexture)
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("Light Pass")
        guard var lightEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor) else {
            return
        }
        lightRenderer.draw(encoder: &lightEncoder, bufferStore: &bufferStore, lightsCount: scene.lights.count, ssao: gaussTexture)
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("Environment Map")
        environmentRenderer.draw(encoder: &lightEncoder, scene: &scene)
        lightEncoder.endEncoding()
        commandBuffer.popDebugGroup()
        bloomStage.draw(commandBuffer: &commandBuffer)
        guard let texturePass = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        commandBuffer.pushDebugGroup("Post Processing Pass")
        postProcessor.draw(encoder: texturePass)
        texturePass.endEncoding()
        commandBuffer.popDebugGroup()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    mutating func updatePalettes(scene: inout GPUSceneDescription) {
        var continousPalette = [simd_float4x4]()
        scene.paletteReferences = []
        for index in scene.entities.indices {
            let palette = generatePalette(objectIdx: index, scene: &scene)
            scene.paletteReferences.append(continousPalette.count ..< continousPalette.count + palette.count)
            continousPalette += palette
        }
        bufferStore.upload(palettes: &continousPalette)
    }
    func generatePalette(objectIdx: Int, scene: inout GPUSceneDescription) -> [simd_float4x4] {
        if scene.skeletonReferences[objectIdx] == .nil {
            return []
        } else {
            let skeletonIdx = scene.skeletonReferences[objectIdx]
            let skeleton = scene.skeletons[skeletonIdx]
            var palette = [matrix_float4x4]()
            palette.reserveCapacity(skeleton.bindTransforms.count)
            let animationReference = scene.animationReferences[skeletonIdx]
            let date = Date().timeIntervalSince1970
            let animation = scene.skeletalAnimations[animationReference.lowerBound]
            let transformations = animation.localTransformation(at: date)
            let pose = skeleton.computeWorldBindTransforms(localBindTransform: transformations)
            for index in skeleton.bindTransforms.indices {
                palette.append(pose[index] * skeleton.inverseBindTransforms[index])
            }
            return palette
        }
    }
}

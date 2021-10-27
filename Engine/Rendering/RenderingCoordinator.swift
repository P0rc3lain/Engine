//
//  Copyright © 2021 Mateusz Stompór. All rights reserved.
//

import Metal
import MetalBinding
import MetalKit

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
    private var bufferStore: BufferStore
    private let canvasSize: CGSize
    let renderingSize: CGSize
    // MARK: - Initialization
    init?(view metalView: MTKView, canvasSize: CGSize, renderingSize: CGSize) {
        guard let device = metalView.device, let bufferStore = BufferStore(device: device),
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
        guard let postProcessorInputTexture = offscreenRenderPassDescriptor.colorAttachments[0].texture,
              let postProcessor = Postprocessor.make(device: device,
                                                     inputTexture: postProcessorInputTexture,
                                                     outputFormat: metalView.colorPixelFormat,
                                                     canvasSize: canvasSize),
              let environmentRenderer = EnvironmentRenderer.make(device: device, drawableSize: metalView.drawableSize),
              let lightRenderer = LightPassRenderer.make(device: device,
                                                         gBufferRenderPassDescriptor: gBufferRenderPassDescriptor,
                                                         drawableSize: renderingSize),
              let gBufferRenderer = GBufferRenderer.make(device: device, drawableSize: renderingSize) else {
            return nil
        }
        self.view = metalView
        self.canvasSize = canvasSize
        self.renderingSize = renderingSize
        self.bufferStore = bufferStore
        self.commandQueue = commandQueue
        self.postProcessor = postProcessor
        self.environmentRenderer = environmentRenderer
        self.gBufferRenderer = gBufferRenderer
        self.lightRenderer = lightRenderer
    }
    public mutating func draw(scene: inout GPUSceneDescription) {
        guard var camera = scene.objects.objects.first(where: { $0.data.type == .camera }),
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable else {
            return
        }
        updatePalettes(scene: &scene)
        bufferStore.omniLights.upload(data: &scene.lights)
        bufferStore.upload(camera: &scene.cameras[camera.data.referenceIdx], transform: &camera.data.transform)
        bufferStore.upload(models: &scene.objects)
        guard var gBufferEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: gBufferRenderPassDescriptor) else {
            return
        }
        commandBuffer.pushDebugGroup("G-Buffer Renderer Pass")
        gBufferRenderer.draw(encoder: &gBufferEncoder, scene: &scene, dataStore: &bufferStore)
        gBufferEncoder.endEncoding()
        commandBuffer.popDebugGroup()
        guard var lightEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor) else {
            return
        }
        commandBuffer.pushDebugGroup("Light Pass")
        lightRenderer.draw(encoder: &lightEncoder, bufferStore: &bufferStore, lightsCount: scene.lights.count)
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("Environment Map")
        environmentRenderer.draw(encoder: &lightEncoder, scene: &scene)
        commandBuffer.popDebugGroup()
        lightEncoder.endEncoding()
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
        for index in scene.objects.indices {
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

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
    let canvasSize: CGSize
    let renderingSize: CGSize
    // MARK: - Initialization
    init?(view metalView: MTKView, canvasSize: CGSize, renderingSize: CGSize) {
        guard let device = metalView.device, let bufferStore = BufferStore(device: device),
              let commandQueue = device.makeCommandQueue() else {
            return nil
        }
        self.view = metalView
        self.canvasSize = canvasSize
        self.renderingSize = renderingSize
        self.bufferStore = bufferStore
        self.commandQueue = commandQueue
        gBufferRenderPassDescriptor = MTLRenderPassDescriptor.gBuffer(device: device, size: renderingSize)
        offscreenRenderPassDescriptor = MTLRenderPassDescriptor.lightenScene(device: device,
                                                                             depthStencil: gBufferRenderPassDescriptor.stencilAttachment.texture!,
                                                                             size: renderingSize)
        postProcessor = Postprocessor.make(device: device,
                                           inputTexture: offscreenRenderPassDescriptor.colorAttachments[0].texture!,
                                           outputFormat: view.colorPixelFormat,
                                           canvasSize: canvasSize)!
        environmentRenderer = EnvironmentRenderer.make(device: device, drawableSize: view.drawableSize)!
        gBufferRenderer = GBufferRenderer.make(device: device, drawableSize: renderingSize)!
        lightRenderer = LightPassRenderer.make(device: device, gBufferRenderPassDescriptor: gBufferRenderPassDescriptor, drawableSize: renderingSize)!
    }
    public mutating func draw(scene: inout GPUSceneDescription) {
        updatePalettes(scene: &scene)
        bufferStore.omniLights.upload(data: &scene.lights)
        var camera = scene.objects.objects.first(where: { $0.data.type == .camera })!
        bufferStore.upload(camera: &scene.cameras[camera.data.referenceIdx], transform: &camera.data.transform)
        bufferStore.upload(models: &scene.objects)
        let commandBuffer = commandQueue.makeCommandBuffer()!
        commandBuffer.pushDebugGroup("G-Buffer Renderer Pass")
        var gBufferEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: gBufferRenderPassDescriptor)!
        gBufferRenderer.draw(encoder: &gBufferEncoder, scene: &scene, dataStore: &bufferStore)
        gBufferEncoder.endEncoding()
        commandBuffer.popDebugGroup()
        var lightEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: offscreenRenderPassDescriptor)!
        commandBuffer.pushDebugGroup("Light Pass")
        lightRenderer.draw(encoder: &lightEncoder, bufferStore: &bufferStore, lightsCount: scene.lights.count)
        commandBuffer.popDebugGroup()
        commandBuffer.pushDebugGroup("Environment Map")
        environmentRenderer.draw(encoder: &lightEncoder, scene: &scene)
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
